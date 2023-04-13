require_relative 'lib/utils'
require_relative 'lib/parser/parser_wrapper'
require_relative 'lib/quality/quality'

def configure_ruby()
  Dir.glob(File.dirname(__FILE__) + '/plugins/*').each do |plugin_directory|
    plugin_entry = plugin_directory + '/' + File.basename(plugin_directory) + '.rb';
    puts "require #{plugin_entry}"
    require plugin_entry
  end
end

def quality(record)
  Quality.new(record, false)
end

def quality!(record)
  Quality.new(record, true)
end
