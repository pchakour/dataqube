require_relative '../../../core/transformer'

class Ruby < Dataqube::Transformer
  config_param :once, :string, default: nil
  config_param :each, :string, default: ""

  def initialize()
    super("ruby")
  end

  def once(rule_tag, params)
    if (params[:once])
      params[:once]
    else
      ""
    end
  end

  def each(rule_tag, params)
    params[:each]
  end
end