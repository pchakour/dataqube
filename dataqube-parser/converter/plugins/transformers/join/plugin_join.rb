require_relative '../../../core/transformer'

class Join < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Join events"

  rule_tag = config_schema do
    required(:rule_tag).filled(:string).description("Tag of a rule")
  end

  predicate = config_schema do
    required(:predicate).filled(:string).description("Predicate")
  end

  plugin_config do
    required(:by)
    .filled(:string)
    .description("Key shared between events to join. This field is a ruby instruction.")

    required(:from)
    .hash(rule_tag)
    .description("Determine the beginning of a join section")

    required(:until)
    .hash(rule_tag)
    .description("Determine the end of a join section")

    required(:using)
    .array(:hash) do
      required(:when).hash(rule_tag | predicate).description("When apply the code")
      required(:code).filled(:string).description("Code to execute")
    end
    .description("What to do to join events")
  end

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