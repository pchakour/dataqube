require_relative './plugins_loader'

class AssertionsLoader < PluginsLoader
  def initialize(logger)
    super('../plugins/assertions', logger)
  end

  def start()
  end
end