require_relative '../../../core/transformer'

class Date < Dataqube::Transformer
  plugin_desc "Convert a string as a Date object"
  plugin_license "community"

  desc "Source to get date string"
  config_param :source, :string
  desc "Target to write the date object. By default, the source will be overwrite with the date object"
  config_param :target, :string, default: nil
  desc "Date format"
  config_param :format, :string, default: nil
    
  def initialize()
    super("date")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    source = params[:source]
    target = params.key?("target") ? params[:target] : "timestamp"
    %{
      timestamp = parse_timestamp(#{record(source)}, '#{params[:format]}')
      #{record(target)} = timestamp
    }
  end
end