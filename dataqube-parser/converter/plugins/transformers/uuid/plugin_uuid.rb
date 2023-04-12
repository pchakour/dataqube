require_relative '../../../core/transformer'

class Uuid < Dataqube::Transformer
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