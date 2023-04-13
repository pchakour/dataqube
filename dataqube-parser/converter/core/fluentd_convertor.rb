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

    config.content["inputs"].each do |input|
      conversion << convert_input(input)
    end

    config.content["rules"].each do |rule|
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

    config.content["outputs"].each do |output|
      conversion << convert_output(output)
    end

    if config.content.key?('autostop') && config.content['autostop']['enabled']
      conversion << "
        <match **>
          @type autoshutdown
          timeout #{config.content['autostop']['timeout'] || 10}
        </match>
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
    if rule.key?("when") && rule["when"].key?("from")
      conversion << "<filter #{rule["when"]["from"]}>\n"
    else
      conversion << "<filter *>\n"
    end
    each_rule = get_each(rule).gsub(/^\s*$\n/, '')
    conversion << %{
  @type dataqube
  init "${
    begin
      #{get_once(rule).gsub(/^\s*$\n/, '')}
    rescue => e
      puts 'Error when excuting init code of rule #{rule['tag']}'
      raise e
    end
  }"
  code "${
    begin
      #{rule['when'] ? wrap_with_when(rule['when'], each_rule) : each_rule}
    rescue => e
      puts 'Error when excuting each code of rule #{rule['tag']} tags=' + record['_dataqube.tags'].to_s
      raise e
    end
    record
  }"
}

    conversion << "</filter>\n"

    return conversion
  end

  private

  def whap_with_when(predicate, text)
    %{
      if #{predicate}
        #{text}
      end
    }
  end

  def get_once(rule)
    conversion = ""
    if rule["extract"]
      rule["extract"].each do |extractor|
        conversion << get_plugin_once(rule["tag"], @extractors_loader, extractor)
      end
    end

    if rule["transform"]
      rule["transform"].each do |transformer|
        conversion << get_plugin_once(rule["tag"], @transformers_loader, transformer)
      end
    end

    if rule["assert"]
      rule["assert"].each do |assertion|
        conversion << get_plugin_once(rule["tag"], @assertions_loader, assertion)
      end
    end

    return conversion
  end

  def get_each(rule)
    conversion = ""
    if rule["extract"]
      rule["extract"].each do |extractor|
        extractor_conversion = ''
        extractor_conversion << get_plugin_each(rule["tag"], @extractors_loader, extractor)
        if extractor[:when]
          extractor_conversion = whap_with_when(extractor[:when], extractor_conversion)
        end
        conversion << extractor_conversion
      end
      conversion << %{
        if !record.key?('_dataqube.quality') || !record['_dataqube.quality'].any? { |stamp| stamp[:tag] == '#{rule['tag']}' }
          if !record.key?('_dataqube.tags')
            record['_dataqube.tags'] = []
          end
          record['_dataqube.tags'].append('#{rule['tag']}')
        else
          return record
        end
      }
    else
      conversion << %{
        if !record.key?('_dataqube.tags')
          record['_dataqube.tags'] = []
        end
        record['_dataqube.tags'].append('#{rule['tag']}')
      }
    end

    if rule["transform"]
      rule["transform"].each do |transformer|
        transformer_conversion = get_plugin_each(rule["tag"], @transformers_loader, transformer)
        if transformer[:when]
          transformer_conversion = whap_with_when(transformer[:when], transformer_conversion)
        end
        conversion << transformer_conversion
      end
    end

    if rule["assert"]
      rule["assert"].each do |assertion|
        assertion_conversion = get_plugin_each(rule["tag"], @assertions_loader, assertion)
        if assertion[:when]
          assertion_conversion = whap_with_when(assertion[:when], assertion_conversion)
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