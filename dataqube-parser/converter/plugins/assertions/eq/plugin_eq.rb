require_relative '../../../core/assertion'

class Eq < Dataqube::Assertion
  config_param :source, :string, multi: true
  config_param :value, :any
  config_param :expected, ['failure', 'success'], default: 'success'

  def initialize()
    super("eq")
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
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} not matching \'#{params[:value]}\'"}')
            .expect(record[field])
            .toBe('#{params[:value]}')
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} match \'#{params[:value]}\'"}')
            .expect(record[field])
            .not
            .toBe('#{params[:value]}')
        end
      end
    }
  end
end