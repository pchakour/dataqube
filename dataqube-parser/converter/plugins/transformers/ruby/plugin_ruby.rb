require_relative '../../../core/transformer'

class Ruby < Dataqube::Transformer
  plugin_desc "Execute ruby code"
  plugin_license "community"

  desc "Code executed once at the startup. Could be useful to initialize some variables."
  config_param :once, :string, default: nil
  desc "Code executed for each event"
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