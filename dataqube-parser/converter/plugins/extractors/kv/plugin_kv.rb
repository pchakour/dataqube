require_relative '../../../core/extractor'

class Kv < Dataqube::Extractor
  config_param :source, :string

  def initialize()
    super("kv")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      kv_result = {}
      kv_result = parse_kv(#{record(params[:source])})
      record = merge_hash(record, kv_result)
    }
  end
end