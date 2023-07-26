require_relative '../errors/missing_parameter'
require_relative '../errors/bad_parameter_type'
require_relative '../errors/unknown_parameter'

$last_description = nil
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
      'license' => 'unknown',
      'description' => nil,
      'details' => nil,
      'params' => []
    }
  end
end

def config_param(name, type, options = nil)
  plugin_config_init(plugin_type, plugin_name)

  $config_param_register[plugin_type][plugin_name]['params'].push({
    'name' => name,
    'type' => type,
    'options' => options,
    'description' => $last_description
  })

  $last_description = nil
end

def desc(description)
  $last_description = description
end


def plugin_desc(description)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name]['description'] = description
end

def plugin_license(license)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name]['license'] = license
end

def plugin_details(details)
  plugin_config_init(plugin_type, plugin_name)
  $config_param_register[plugin_type][plugin_name]['details'] = details
end

def get_plugin_config(type, plugin)
  name = plugin['type']
  parameters = $config_param_register[type][name]['params']
  if !parameters
    parameters = []
  end
  common_parameters = $config_param_register['common']['plugin']['params']
  type_parameters = []

  if $config_param_register['common'][type]
    type_parameters = $config_param_register['common'][type]['params']
  end

  return common_parameters + parameters + type_parameters
end

def get_type(var)
  type = var.class.to_s.downcase
  if type == 'trueclass'
    type = 'boolean'
  end

  return type
end

def check_types(type, plugin)
  name = plugin['type']
  parameters = get_plugin_config(type, plugin)

  plugin.each do |parameter_name, parameter_value|
    if parameter_name != 'type'
      parameter = parameters.find { |p| p['name'].to_s == parameter_name }
      if parameter
        if parameter_value.class.to_s.downcase == 'array' && parameter['options'] && parameter['options'][:multi]
          parameter_value.each do |x|
            if parameter != nil
              if parameter['type'].is_a?(Array)
                if !parameter['type'].include?(x)
                  fail BadParameterType, "Value '#{x}' of parameter '#{parameter_name}' of plugin '#{name}' in #{type}s section is not one of #{parameter['type']}"
                end
              elsif parameter['type'] != :any && parameter['type'].to_s != get_type(x)
                fail BadParameterType, "Unexpected type #{get_type(x)} for parameter '#{parameter_name}' of plugin '#{name}' in #{type}s section (expected #{parameter['type'].to_s})"
              end
            end
          end
        elsif parameter != nil
          if parameter['type'].is_a?(Array)
            if !parameter['type'].include?(parameter_value)
              fail BadParameterType, "Value '#{parameter_value}' of parameter '#{parameter_name}' of plugin '#{name}' in #{type}s section is not one of #{parameter['type']}"
            end
          elsif parameter['type'] != :any && parameter['type'].to_s != get_type(parameter_value)
            fail BadParameterType, "Unexpected type #{get_type(parameter_value)} for parameter '#{parameter_name}' of plugin '#{name}' in #{type}s section (expected #{parameter['type'].to_s})"
          end
        end
      end
    end
  end
end

def check_required(type, plugin)
  name = plugin['type']
  parameters = get_plugin_config(type, plugin)

  required_parameters = parameters.select { |parameter|
    !parameter['options'] || !parameter['options'].key?(:default)
  }

  required_parameters.each do |required_parameter|
    parameter_name = required_parameter['name'].to_s
    if !plugin.key?(parameter_name)
      fail MissingParameter, "Missing parameter '#{parameter_name}' for plugin '#{name}' in #{type}s section"
    end
  end
end

def check_unknown(type, plugin)
  name = plugin['type']
  parameters = get_plugin_config(type, plugin)
  plugin.each do |parameter_name, parameter_value|
    if parameter_name != 'type'
      exists = parameters.find { |p| p['name'].to_s == parameter_name.to_s }
      if !exists
        fail UnknownParameter, "Unknown parameter '#{parameter_name}' for plugin '#{name}' in #{type}s section"
      end
    end
  end
end

def apply_defaults(type, plugin)
  parameters = get_plugin_config(type, plugin)
  parameters.each do |parameter|
    if parameter['options'] && parameter['options'].key?(:default)
      if !plugin.key?(parameter['name'].to_s)
        plugin[parameter['name']] = parameter['options'][:default]
      end
    end
  end
end

def transform_symbols(plugin)
  plugin.transform_keys!(&:to_sym)
end

def config_validate_and_apply_defaults(config)
  config.content['inputs'].each do |input|
    check_required('input', input)
    check_types('input', input)
    check_unknown('input', input)
    apply_defaults('input', input)
    transform_symbols(input)
  end
  
  config.content['outputs'].each do |output|
    check_required('output', output)
    check_types('output', output)
    check_unknown('output', output)
    apply_defaults('output', output)
    transform_symbols(output)
  end
  
  config.content['rules'].each do |rule|
    if rule['extract']
      rule['extract'].each do |extractor|
        check_required('extractor', extractor)
        check_types('extractor', extractor)
        check_unknown('extractor', extractor)
        apply_defaults('extractor', extractor)
        transform_symbols(extractor)
      end
    end
    if rule['transform']
      rule['transform'].each do |transformer|
        check_required('transformer', transformer)
        check_types('transformer', transformer)
        check_unknown('transformer', transformer)
        apply_defaults('transformer', transformer)
        transform_symbols(transformer)
      end
    end
    if rule['assert']
      rule['assert'].each do |assertion|
        check_required('assertion', assertion)
        check_types('assertion', assertion)
        check_unknown('assertion', assertion)
        apply_defaults('assertion', assertion)
        transform_symbols(assertion)
      end
    end
  end
end