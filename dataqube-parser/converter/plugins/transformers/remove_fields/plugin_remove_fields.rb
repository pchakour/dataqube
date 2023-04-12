require_relative '../../../core/transformer'

class RemoveFields < Dataqube::Transformer
  config_param :source, :string

  def initialize()
    super("remove_fields")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    sources = params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")
    record_delete(sources)
  end
end