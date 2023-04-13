require_relative '../../../core/assertion'

class Contains < Dataqube::Assertion
  config_param :source, :string
  config_param :value, :any
  config_param :expected, ['failure', 'success'], default: 'success'

  def initialize()
    super("contains")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      if #{record(params[:source])}.kind_of?(Array)
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:message] || "Field #{params[:source].to_s} must contain #{value(params[:value]).gsub("'", "\\\\\\\\'")}"}')
            .expect(#{record(params[:source])})
            .toContain(#{value(params[:value])})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:message] || "Field #{params[:source].to_s} must not contain #{value(params[:value]).gsub("'", "\\\\\\\\'")}"}')
            .expect(#{record(params[:source])})
            .not
            .toContain(#{value(params[:value])})
        end
      end
    }
  end
end