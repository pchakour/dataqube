require 'yaml'
require 'optparse'
require 'pathname'
require 'tmpdir'
require 'securerandom'
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

  opts.on("-o [PATH]", "--output-config [PATH]", "Path to the output configuration generated for fluentd") do |c|
    options[:output] = c
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
if options[:output]
  output_path = File.expand_path options[:output], Dir.pwd
else
  tmpdir = Dir.tmpdir()
  uuid = SecureRandom.uuid
  output_path =  "#{tmpdir}/fluentd-#{uuid}.conf"
end

File.open(output_path, 'w') { |file| file.write(conversion) }
pid = Process.spawn(
  ENV.to_h,
  Gem.ruby,
  "vendor/bundle/ruby/3.1.0/gems/fluentd-1.16.2/bin/fluentd",
  "--under-supervisor",
  "-c",
  output_path,
  chdir: "#{File.dirname(__FILE__)}/../../.."
)

Signal.trap("INT") do
  Process.kill("KILL", pid)
  exit 130
end

Signal.trap("TERM") do
  Process.kill("KILL", pid)
  exit 143
end

Process.wait(pid)
File.delete(output_path)

print "Injection #{injection_id} done\n";
if injection_id
  exit_status = $?
  status = 'done'
  if !exit_status.success?
    status = 'error'
  end
  dataqube.end_injection(injection_id, status);
end
