require_relative '../../../core/transformer'

class Date < Dataqube::Transformer
  config_param :source, :string
  config_param :target, :string, default: nil
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