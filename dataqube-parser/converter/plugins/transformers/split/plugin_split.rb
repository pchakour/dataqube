require_relative '../../../core/transformer'

class Split < Dataqube::Transformer
  config_param :source, :string, multi: true

  def initialize()
    super("split")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      record = split(record, sources)
    }
  end
end