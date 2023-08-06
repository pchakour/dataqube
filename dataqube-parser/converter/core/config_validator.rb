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

def get_plugin_schema(type, plugin)
  name = plugin[:type]
  return $config_param_register[type][name][:schema_raw]
end

def get_schema(type)
  schemas = []

  $config_param_register[type].each{ |key, properties|
    current_schema = config_schema do
      required(:type).filled(:string, eql?: key)
    end

    if properties[:schema_raw]
      current_schema = current_schema.and(properties[:schema_raw])
    end

    if $config_param_register['common'][type] && $config_param_register['common'][type][:schema_raw]
      current_schema.and($config_param_register['common'][type][:schema_raw])
    end
    schemas.push(current_schema)
  }

  if schemas.length > 0
    schema = schemas.pop
    schemas.each{ |s| schema = schema.or(s) }
    schema
  end
end

def get_complete_schema
  config_schema do
    optional(:system).filled(:hash).schema(SYSTEM_SCHEMA)

    required(:inputs).value(:array, min_size?: 1).each do
      hash(get_schema('input'))
    end

    required(:outputs).value(:array, min_size?: 1).each do
      hash(get_schema('output'))
    end
    
    optional(:rules).value(:array).each do
      hash do
        required(:tag).filled(:string)
        optional(:when).filled(:string)
        optional(:extract).value(:array, min_size?: 1).each do
          hash(get_schema('extractor'))
        end
        optional(:transform).value(:array, min_size?: 1).each do
          hash(get_schema('transformer'))
        end
        optional(:assert).value(:array, min_size?: 1).each do
          hash(get_schema('assertion'))
        end
      end
    end
  end
end

def apply_defaults_next(schema_type, config, key)
  if schema_type.type.class == Dry::Types::Constrained
    apply_defaults_next(p.type, config, key)
  elsif schema_type.type.class == Dry::Types::Array::Member
    apply_defaults_next(p.type.member, config, key)
  elsif schema_type.type.class == Dry::Types::Schema
    schema_key_map = {}
    schema_type.keys.each { |t, e| schema_key_map = schema_key_map.merge({ t.name => t }) }
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
  schema.each{ |key, p|
    if !config.key?(key)
      config[key] = p.meta[:default]
    end

    apply_defaults_next(p, config, key)
  }
end

def apply_defaults_plugins(plugin_type, config)
  config.each{|plugin|
    plugin_schema = get_plugin_schema(plugin_type, plugin)
    if plugin_schema
      apply_defaults(plugin_schema.types, plugin)
    end
  }
end

def apply_defaults_system(config)
  apply_defaults(SYSTEM_SCHEMA.types, config)
end

def apply_defaults_rules(config)
  config.each do |rule|
    if rule[:extract]
      apply_defaults_plugins('extractor', rule[:extract])
    end
    if rule[:transform]
      apply_defaults_plugins('transformer', rule[:transform])
    end
    if rule[:assert]
      apply_defaults_plugins('assertion', rule[:assert])
    end
  end
end

def config_validate_and_apply_defaults(config)
  complete_config_schema = get_complete_schema
  validation_result = complete_config_schema.call(config.content)
  if !validation_result.success?
    fail ConfigurationMisformat, validation_result.errors.to_h
  end

  apply_defaults_system(config.content[:system])
  apply_defaults_plugins('input', config.content[:inputs])
  apply_defaults_plugins('output', config.content[:outputs])
  apply_defaults_rules(config.content[:rules])
end