require_relative '../../../core/transformer'

class Join < Dataqube::Transformer
  plugin_desc "Join events"
  plugin_license "community"

  rule_tag_type = { :type => :string, :desc => 'Check if an event is tagged by the rule_tag' }

  desc "Key shared between events to join. This field is a ruby instruction."
  config_param :by, :string
  desc "Determine the beginning of a join section"
  config_param :from, { :rule_tag => rule_tag_type }
  desc "Determine the end of a join section"
  config_param :until, { :rule_tag => rule_tag_type }
  desc "What to do to join events"
  config_param :using, {
    :when => {
      :type => {
        :rule_tag => rule_tag_type,
        :predicate => { :type => :string, :desc => 'Use Ruby predicate' }
      },
    },
    :code => { :type => :string, :desc => 'Ruby code to execute when conditions are met' }
  },
  multi: true

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