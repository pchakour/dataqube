require_relative '../../../core/assertion'

class Size < Dataqube::Assertion
  config_param :source, :string
  config_param :min, :integer, default: 0
  config_param :max, :integer, default: 0
  config_param :expected, ['failure', 'success'], default: 'success'

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