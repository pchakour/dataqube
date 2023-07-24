require_relative '../../../core/assertion'

class Size < Dataqube::Assertion
  plugin_desc "Check if the size of an array is include between a min and a max. Min and max are included."
  plugin_license "community"

  desc "Source field to check. The field must be an array."
  config_param :source, :string
  desc "Min value"
  config_param :min, :integer, default: 0
  desc "Max value"
  config_param :max, :integer, default: 0

  def initialize()
    super("size")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      if #{record(params[:source])}.kind_of?(Array)
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} size must be between or equal to #{params[:min]} and #{params[:max]}"}')
            .expect(#{record(params[:source])}.size)
            .toBeBetweenOrEqual(#{params[:min]}, #{params[:max]})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} size must be between or equal to #{params[:min]} and #{params[:max]}"}')
            .expect(#{record(params[:source])}.size)
            .not
            .toBeBetweenOrEqual(#{params[:min]}, #{params[:max]})
        end
      end
    }
  end
end