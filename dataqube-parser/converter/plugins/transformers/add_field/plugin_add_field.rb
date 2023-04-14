require_relative '../../../core/transformer'

class AddField < Dataqube::Transformer
  config_param :name, :string
  config_param :value, :string

  def initialize()
    super("add_field")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      #{record(params[:name])} = #{value(params[:value])}
    }
  end
end