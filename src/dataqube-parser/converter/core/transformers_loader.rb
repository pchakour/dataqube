require_relative './plugins_loader'

class TransformersLoader < PluginsLoader
  def initialize(logger)
    super('../plugins/transformers', logger)
  end

  def start()
  end
end