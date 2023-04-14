require 'yaml'
require 'optparse'
require 'pathname'
require_relative '../converter/core/core'
require_relative './dataqube_api'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  opts.on("-d", "--build-doc", "Build plugin documentation") do |d|
    options[:doc] = d
  end

  opts.on("-p", "--parser=[PARSER]", "Parser to use, one of [fluentd]") do |p|
    options[:parser] = p
  end

  opts.on("-c", "--config=[PATH]", "Config path") do |c|
    options[:config] = c
  end

  opts.on("--project-id=[ID]", "Project id") do |projectId|
    options[:projectId] = projectId
  end
end.parse!

core = Core.new()
core.start()

if options[:doc]
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

raise OptionParser::MissingArgument if options[:config].nil?
options[:parser] = 'fluentd' if options[:parser].nil?

rules = nil
project = nil

if !options[:projectId].nil?
  # Dataqube mode
  dataqube = Dataqube::Api.new
  project = dataqube.get_project(options[:projectId]);
  rules_response = dataqube.get_rules(project['rules']);

  if rules_response
    rules = YAML.load(rules_response['rules'])['rules']
  end


end

config_path = Pathname.new(options[:config]).realpath.to_s
conversion = core.convert(config_path, project, rules)
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