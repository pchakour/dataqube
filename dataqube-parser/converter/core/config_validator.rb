require 'dry-schema'
require_relative '../errors/missing_parameter'
require_relative '../errors/configuration_misformat'
require_relative '../errors/bad_parameter_type'
require_relative '../errors/unknown_parameter'
require_relative './config_schema'

$config_param_register = {}

def plugin_name
  path = caller_locations(2, 1)[0].path.to_s
  matches = path.match(/\/plugin_(\w+)\.rb/)
  if matches
    return matches[1]
  end

  return caller_locations(2,1)[0].to_s.match(/(?<=<class:)(\w+)(?=>')/)[0].downcase
end

def plugin_type
  plugin_type = File.basename(File.dirname(File.dirname(caller_locations(2,1)[0].path)))
  return plugin_type != 'converter' ? plugin_type.chop : 'common';
end

def plugin_config_init(type, name)
  if !$config_param_register[type]
    $config_param_register[type] = {}
  end

  if !$config_param_register[type][name]
    $config_param_register[type][name] = {
      :license => 'unknown',
      :description => nil,
      :details => nil,
      :params => [],
      :schema => nil,
      :schema_raw => nil,
    }
  end
end

def plugin_config(&block)
  plugin_config_init(plugin_type, plugin_name)
  schema_raw = config_schema(&block)
  $config_param_register[plugin_type][plugin_name][:schema_raw] = schema_raw
  $config_param_register[plugin_type][plugin_name][:schema] = schema_raw.json_schema(loose: true).to_json
end

def plugin_desc(description)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name][:description] = description
end

def plugin_license(license)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name][:license] = license
end

def plugin_details(details)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name][:details] = details
end

def get_plugin_schemas(type, plugin)
  name = plugin[:type]
  schemas = []
  if $config_param_register[type][name] && $config_param_register[type][name][:schema_raw]
    schemas.push($config_param_register[type][name][:schema_raw])
  end
  if $config_param_register['common']['plugin'] && $config_param_register['common']['plugin'][:schema_raw]
    schemas.push($config_param_register['common']['plugin'][:schema_raw])
  end

  if $config_param_register['common'][type] && $config_param_register['common'][type][:schema_raw]
    schemas.push($config_param_register['common'][type][:schema_raw])
  end

  schemas
end

def apply_defaults_next(schema_type, config, key)
  if !schema_type.respond_to?(:type)
    return
  end
  
  if schema_type.type.class == Dry::Types::Constrained
    apply_defaults_next(schema_type.type, config, key)
  elsif schema_type.type.class == Dry::Types::Array::Member
    apply_defaults_next(schema_type.type.member, config, key)
  elsif schema_type.type.class == Dry::Types::Schema
    schema_key_map = {}
    schema_type.keys.each { |subkey| schema_key_map = schema_key_map.merge({ subkey.name => subkey }) }
    if !config[key]
      config[key] = {}
    end

    subconfigs = config[key]
    if !subconfigs.is_a?(Array)
      subconfigs = [subconfigs]
    end

    subconfigs.each { |subconfig|  apply_defaults(schema_key_map, subconfig) }
  end
end

def apply_defaults(schema, config)
  if !config
    return
  end
  schema.each{ |key, p|
    if !config.key?(key)
      config[key] = p.meta[:default]
    end

    apply_defaults_next(p, config, key)
  }
end

def apply_defaults_plugins(plugin_type, config)
  config.each{|plugin|
    schemas = get_plugin_schemas(plugin_type, plugin)
    schemas.each{|schema|
      apply_defaults(schema.types, plugin)
    }
  }
end

def apply_defaults_system(config)
  apply_defaults(SYSTEM_SCHEMA.types, config)
end

def validate_and_apply_defaults_rules(config)
  config.each do |rule|
    other_info = "Rule tag=#{rule[:tag]}"
    if rule[:extract]
      validate_schema_plugin('extractor', rule[:extract], other_info)
      apply_defaults_plugins('extractor', rule[:extract])
    end
    if rule[:transform]
      validate_schema_plugin('transformer', rule[:transform], other_info)
      apply_defaults_plugins('transformer', rule[:transform])
    end
    if rule[:assert]
      validate_schema_plugin('assertion', rule[:assert], other_info)
      apply_defaults_plugins('assertion', rule[:assert])
    end
  end
end

def validate_schema_system(config)
  validation_result = SYSTEM_SCHEMA.call(config)
  if !validation_result.success?
    fail ConfigurationMisformat, "System configuration invalid: " + validation_result.errors.to_h.to_json
  end
end

def validate_schema_plugin(plugin_type, config, other_info = nil)
  config.each_with_index{|plugin, index|
    schemas = get_plugin_schemas(plugin_type, plugin) 
    schemas.each {|schema| 
      validation_result = schema.call(plugin)
      if !validation_result.success?
        error = "#{plugin_type} at position #{index} named #{plugin[:type]} has an invalid configuration: " + validation_result.errors.to_h.to_json
        if other_info
          error = "[#{other_info}] #{error}"
        end
        fail ConfigurationMisformat, error
      end
    }
  }
end

def config_validate_and_apply_defaults(config)
  validate_schema_system(config.content[:system])
  apply_defaults_system(config.content[:system])
  validate_schema_plugin('input', config.content[:inputs])
  apply_defaults_plugins('input', config.content[:inputs])
  validate_schema_plugin('output', config.content[:outputs])
  apply_defaults_plugins('output', config.content[:outputs])
  validate_and_apply_defaults_rules(config.content[:rules])
end