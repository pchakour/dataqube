require_relative './plugins_loader'

class ExtractorsLoader < PluginsLoader
  def initialize(logger)
    super('../plugins/extractors', logger)
  end

  def start()
  end
end