require_relative '../../../core/assertion'

class Contains < Dataqube::Assertion
  plugin_desc "Check if an array contains a specific value"
  plugin_license "community"

  desc "Source field to check. The field must be an array."
  config_param :source, :string
  desc "Value to find in the array"
  config_param :value, :any

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
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Field #{params[:source].to_s} must contain #{value(params[:value]).gsub("'", "\\\\\\\\'")}"}')
            .expect(#{record(params[:source])})
            .toContain(#{value(params[:value])})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Field #{params[:source].to_s} must not contain #{value(params[:value]).gsub("'", "\\\\\\\\'")}"}')
            .expect(#{record(params[:source])})
            .not
            .toContain(#{value(params[:value])})
        end
      end
    }
  end
end