require_relative 'utils'
require_relative 'quality/quality'

def configure_ruby()
  Dir.glob(File.dirname(__FILE__) + '/../plugins/*').each do |plugin_directory|
    plugin_entry = plugin_directory + '/' + File.basename(plugin_directory) + '.rb';
    require plugin_entry
  end
end

def quality(record)
  Quality.new(record, false)
end

def quality!(record)
  Quality.new(record, true)
end
