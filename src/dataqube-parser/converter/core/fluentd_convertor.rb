class FluentdConvertor
  def initialize(inputs_loader, outputs_loader, extractors_loader, transformers_loader, assertions_loader)
    @inputs_loader = inputs_loader
    @outputs_loader = outputs_loader
    @extractors_loader = extractors_loader
    @assertions_loader = assertions_loader
    @transformers_loader = transformers_loader
  end

  def convert(config)
    conversion = ""

    config.content[:inputs].each do |input|
      conversion << convert_input(input)
    end

    conversion << %{
      <filter *>
        @type record_modifier
        # set UTF-8 encoding information to string.
        char_encoding utf-8
      </filter>
      <filter *>
        @type dataqube
        init "${
          @map = { 'count' => 0, 'broadcasted_metric' => 0 }
        }"
        code "${
          @map['count'] = @map['count'] + 1
          if @map['count'] - @map['broadcasted_metric'] > 100
            @map['broadcasted_metric'] = @map['count']
            puts '{ \\\"metrics\\\": { \\\"received_events\\\": ' + @map['broadcasted_metric'].to_s + ' } }'
          end
          record
        }"
      </filter>
    }

    config.content[:rules].each do |rule|
      conversion << convert_rule(rule)
    end

    conversion << %{
      <filter *>
        @type dataqube
        init ""
        code "${
          if !record.key?('_dataqube.quality')
            record.delete('@metadata')
          end
          record
        }"
      </filter>
    }

    config.content[:outputs].each do |output|
      conversion << convert_output(output)
    end

    if config.content.key?(:system) && config.content[:system].key?(:autostop) && config.content[:system][:autostop][:enabled]
      conversion << "
      <label @FLUENT_LOG>
        <match fluent.*>
          @type autoshutdown
          timeout #{config.content[:system][:autostop][:timeout] || 10}
        </match>
      </label>
      "
    end


    conversion
  end

  def convert_input(input)
    conversion = "\n"
    conversion << get_plugin_raw(@inputs_loader, input)
    conversion << "\n"
    return conversion
  end

  def convert_output(output)
    conversion = "\n"
    conversion << get_plugin_raw(@outputs_loader, output)
    conversion << "\n"
    return conversion
  end

  def convert_rule(rule)
    conversion = "\n"
    if rule.key?(:when) && rule[:when].key?(:from)
      conversion << "<filter #{rule[:when][:from]}>\n"
    else
      conversion << "<filter *>\n"
    end
    each_rule = get_each(rule).gsub(/^\s*$\n/, '')
    once_code = get_once(rule).gsub(/^\s*$\n/, '')

    if once_code != ''
      once_code = %{
      begin
        #{once_code}
      rescue => e
        puts 'Error when excuting init code of rule #{rule[:tag]}'
        raise e
      end
      }
    end
    conversion << %{
  @type dataqube
  init "${
    #{once_code}
  }"
  code "${
    begin
      #{rule[:when] ? wrap_with_when(rule[:when][:predicate], each_rule) : each_rule}
    rescue => e
      puts 'Error when excuting each code of rule #{rule[:tag]} tags=' + record['_dataqube.tags'].to_s
      raise e
    end
    record
  }"
}

    conversion << "</filter>\n"

    return conversion
  end

  private

  def wrap_with_when(predicate, text)
    %{
      if #{predicate}
        #{text}
      end
    }
  end

  def get_once(rule)
    conversion = ""
    if rule[:extract]
      rule[:extract].each do |extractor|
        conversion << get_plugin_once(rule[:tag], @extractors_loader, extractor)
      end
    end

    if rule[:transform]
      rule[:transform].each do |transformer|
        conversion << get_plugin_once(rule[:tag], @transformers_loader, transformer)
      end
    end

    if rule[:assert]
      rule[:assert].each do |assertion|
        conversion << get_plugin_once(rule[:tag], @assertions_loader, assertion)
      end
    end

    return conversion
  end

  def get_each(rule)
    conversion = ""
    if rule[:extract]
      rule[:extract].each do |extractor|
        extractor_conversion = ''
        extractor_conversion << get_plugin_each(rule[:tag], @extractors_loader, extractor)
        if extractor[:when]
          extractor_conversion = wrap_with_when(extractor[:when], extractor_conversion)
        end
        conversion << extractor_conversion
      end
      conversion << %{
        if !record.key?('_dataqube.quality') || !record['_dataqube.quality'].any? { |stamp| stamp[:tag] == '#{rule[:tag]}' }
          if !record.key?('_dataqube.tags')
            record['_dataqube.tags'] = []
          end
          record['_dataqube.tags'].append('#{rule[:tag]}')
        else
          return record
        end
      }
    else
      conversion << %{
        if !record.key?('_dataqube.tags')
          record['_dataqube.tags'] = []
        end
        record['_dataqube.tags'].append('#{rule[:tag]}')
      }
    end

    if rule[:transform]
      rule[:transform].each do |transformer|
        transformer_conversion = get_plugin_each(rule[:tag], @transformers_loader, transformer)
        if transformer[:when]
          transformer_conversion = wrap_with_when(transformer[:when], transformer_conversion)
        end
        conversion << transformer_conversion
      end
    end

    if rule[:assert]
      rule[:assert].each do |assertion|
        assertion_conversion = get_plugin_each(rule[:tag], @assertions_loader, assertion)
        if assertion[:when]
          assertion_conversion = wrap_with_when(assertion[:when], assertion_conversion)
        end
        conversion << assertion_conversion
      end
    end

    return conversion
  end

  def get_plugin_once(rule_tag, loader, params)
    plugin = loader.get(params[:type])
    plugin.once(rule_tag, params)
  end

  def get_plugin_each(rule_tag, loader, params)
    plugin = loader.get(params[:type])
    plugin.each(rule_tag, params)
  end

  def get_plugin_raw(loader, params)
    plugin = loader.get(params[:type])
    plugin.raw(:fluentd, params)
  end

end