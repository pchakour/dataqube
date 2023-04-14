require_relative '../../../core/transformer'

class Join < Dataqube::Transformer
  config_param :when, :string, default: nil
  config_param :by, :string
  config_param :from, :hash
  config_param :until, :hash
  config_param :using, :hash, multi: true

  def initialize()
    super("join")
  end

  def once(rule_tag, params)
    %{
      if !@map
        @map = {}
      end
    }
  end

  def each(rule_tag, params)
    key = params[:by]
    from_rule_tag = params[:from]['rule_tag']
    from_predicate = params[:from]['predicate']
    until_rule_tag = params[:until]['rule_tag']
    until_predicate = params[:until]['predicate']
    using_list = params[:using]

    conversion = %{
      if #{get_condition(from_rule_tag, from_predicate)}
        @map[#{key}] = {}
      end

      map = @map[#{key}]
    }

    using_list.each { |item|
      using_when_tag = item['when']['rule_tag']
      using_when_predicate = item['when']['predicate']
      using_code = item['code']
      conversion << %{
        if #{get_condition(using_when_tag, using_when_predicate)} && map != nil
          #{using_code}
        end
      }
    }

    conversion << %{
      if #{get_condition(until_rule_tag, until_predicate)}
        @map.delete(#{key})
      end
    }

    return conversion
  end

  def get_condition(rule_tag, predicate)
    if rule_tag != nil && rule_tag != ''
      return "record['_dataqube.tags'].include?('#{rule_tag}')"
    else
      return predicate
    end
  end
end