
require_relative '../errors/unknown_plugin_name'

class PluginsLoader

  def initialize(plugins_dir, logger)
    @plugins = {}
    Dir.glob(File.dirname(__FILE__) + '/' + plugins_dir + '/**/plugin_*.rb').each do |file|
        require file
        filename = File.basename(file, ".rb")
        filename.slice!("plugin_")
        plugin = eval(filename.split('_').collect(&:capitalize).join + ".new")
        plugin.logger = logger
        @plugins[plugin.name] = plugin
    end
    
  end

  def start()
    
  end

  def get(plugin_name)
    if @plugins.key?(plugin_name)
      return @plugins[plugin_name]
    end

    fail UnknownPluginName, 'Unknown plugin named "' + plugin_name.to_s + '"'
  end
end