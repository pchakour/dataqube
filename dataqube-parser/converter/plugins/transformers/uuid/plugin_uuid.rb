require_relative '../../../core/transformer'

class Uuid < Dataqube::Transformer
  plugin_desc "Generate a unique id in the specified target"
  plugin_license "community"

  desc "Field in which stored the unique id"
  config_param :target, :string

  def initialize()
    super("uuid")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      #{record(params[:target])} = uuid()
    }
  end
end