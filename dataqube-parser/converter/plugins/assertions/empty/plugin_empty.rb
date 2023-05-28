require_relative '../../../core/assertion'

class Empty < Dataqube::Assertion
  config_param :source, :string, multi: true
  config_param :expected, ['failure', 'success'], default: 'success'

  def initialize()
    super("empty")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      if !sources.kind_of?(Array)
        sources = [sources]
      end
      sources.each do |field|
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} are not empty"}')
            .expect(record[field])
            .toBeOneOf('', nil)
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} are empty"}')
            .expect(record[field])
            .not
            .toBeOneOf('', nil)
        end
      end
    }
  end
end