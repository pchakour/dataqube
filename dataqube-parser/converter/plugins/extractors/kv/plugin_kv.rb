require_relative '../../../core/extractor'

class Kv < Dataqube::Extractor
  plugin_desc "Extract data using key value pattern"
  plugin_license "community"

  desc "Source field to use for the extraction"
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