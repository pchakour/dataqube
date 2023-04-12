require_relative './plugins_loader'

class OutputsLoader < PluginsLoader
  def initialize(logger)
    super('../plugins/outputs', logger)
  end

  def start()
  end
end