require_relative './plugins_loader'

class InputsLoader < PluginsLoader
  def initialize(logger)
    super('../plugins/inputs', logger)
  end

  def start()
  end
end