require 'yaml'
require 'optparse'
require 'pathname'
require_relative '../converter/core/core'
require_relative './dataqube_api'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  opts.on("", "--build-json-doc", "Build plugin documentation as json format") do |d|
    options[:docjson] = d
  end

  opts.on("", "--build-text-doc", "Build plugin documentation as text format") do |d|
    options[:doctext] = d
  end

  opts.on("-p [PARSER]", "--parser [PARSER]", "Parser to use, one of [fluentd]") do |p|
    options[:parser] = p
  end

  opts.on("-c [PATH]", "--config [PATH]", "Config path") do |c|
    options[:config] = c
  end

  opts.on("--project-id [ID]", "Project id") do |projectId|
    options[:projectId] = projectId
  end

  opts.on("--project-version [VERSION]", "Project version (default: last)") do |projectVersion|
    options[:projectVersion] = projectVersion
  end
end.parse!

core = Core.new()
core.start()

if options[:doctext]
  $config_param_register.each do |plugin, params|
    splitted = plugin.split('/')
    type = splitted[0]
    name = splitted[1]
    puts "Name: #{name}"
    puts "Type: #{type}"
    puts "Params:"
    params.each do |param|
      puts "\tName: #{param['name']}"
      puts "\tType: #{param['type']}"
      puts "\tRequired: #{param['options'] && param['options'].key?(:default) ? 'No' : 'Yes'}"
      puts "\tDefault: #{param['options'] && param['options'].key?(:default) ? param['options'][:default].to_s : ''}"
      puts "\tMulti: #{param['options'] && param['options'][:multi] ? param['options'][:multi].to_s : 'false'}"
      puts ""
    end
  end
  exit
end

def deep_delete_key(hash, key_to_delete)
  hash.each do |key, value|
    if value.is_a?(Hash)
      deep_delete_key(value, key_to_delete)
    end

    hash.delete(key) if key == key_to_delete
  end
end

if options[:docjson]
  print  deep_delete_key($config_param_register.dup, :schema_raw).to_json
  exit
end

raise OptionParser::MissingArgument if options[:config].nil?
options[:parser] = 'fluentd' if options[:parser].nil?
options[:projectVersion] = 'last' if options[:projectVersion].nil?

rules = nil
project = nil
injection_id = nil

if !options[:projectId].nil?
  # Dataqube mode
  dataqube = Dataqube::Api.new
  project = dataqube.get_project(options[:projectId])
  rules_response = dataqube.get_rules(project['rules'])

  if rules_response
    rules = YAML.load(rules_response['rules'])['rules']
    injection_id = dataqube.begin_injection(project['id'], options[:projectVersion])
  end
end

config_path = Pathname.new(options[:config]).realpath.to_s
conversion = core.convert(config_path, injection_id, rules)
output_path = "#{File.dirname(__FILE__)}/../#{options[:parser]}.conf"
File.open(output_path, 'w') { |file| file.write(conversion) }
fluentd_dir = "#{File.dirname(__FILE__)}/../fluentd"
env = { "GEM_PATH" => fluentd_dir }
pid = Process.spawn(
  env,
  "#{fluentd_dir}/bin/#{options[:parser]}",
  "--under-supervisor",
  "-c",
  output_path,
  "-p",
  "#{fluentd_dir}/plugins/fluent-plugin-dataqube",
  "-p",
  "#{fluentd_dir}/plugins/fluent-plugin-autoshutdown"
)

Signal.trap("INT") do
  # code à exécuter lorsque le signal INT est capturé
  puts "Signal INT capturé. Arrêt du programme..."
  Process.kill("KILL", pid)
  exit
end

Process.wait(pid)

print "Injection #{injection_id} done\n";
if injection_id
  exit_status = $?
  status = 'done'
  if !exit_status.success?
    status = 'error'
  end
  dataqube.end_injection(injection_id, status);
end
