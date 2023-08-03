require_relative '../../../core/transformer'

class Uuid < Dataqube::Transformer
  plugin_desc "Generate a unique id in the specified target"
  plugin_license "community"

  plugin_config do
    required(:target).filled(:string).description("Field in which stored the unique id")
  end

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