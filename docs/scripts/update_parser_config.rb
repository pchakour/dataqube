#! /bin/ruby
require 'json'
require 'fileutils'


DIRNAME = __dir__
PARSER_PATH = "#{DIRNAME}/../../parser.sh"
TMP_JSON_DOC = "#{DIRNAME}/.doc.json"

OUTPUT_DIR = "#{DIRNAME}/../documentation/parsing_tool/plugins"
INPUTS_DOC = "#{OUTPUT_DIR}/inputs"
OUTPUTS_DOC = "#{OUTPUT_DIR}/outputs"
EXTRACTORS_DOC = "#{OUTPUT_DIR}/extractors"
TRANSFORMERS_DOC = "#{OUTPUT_DIR}/transformers"
ASSERTIONS_DOC = "#{OUTPUT_DIR}/assertions"

build_doc_output = `#{PARSER_PATH} --build-json-doc`
JSON_DOC = JSON.parse(build_doc_output)
COMMON_PLUGIN_SCHEMA = JSON.parse(JSON_DOC['common']['plugin']['schema'])

FileUtils.rm_r(OUTPUT_DIR)
FileUtils.mkdir_p(INPUTS_DOC)
FileUtils.mkdir_p(OUTPUTS_DOC)
FileUtils.mkdir_p(EXTRACTORS_DOC)
FileUtils.mkdir_p(TRANSFORMERS_DOC)
FileUtils.mkdir_p(ASSERTIONS_DOC)

def write_file(file_path, content)
  File.open(file_path, 'w') do |file|
    file.write(content)
  end
end

def get_property_type(property_info)
  result = ''
  if property_info.key?('type')
    type = property_info['type']
    if type == 'array'
      if property_info.key?('items')
        result = "#{property_info['type']}&lt;#{property_info['items']['type']}&gt;"
      elsif property_info.key?('anyOf')
        result = "#{property_info['type']}&lt;#{property_info['anyOf'].map { |t| t['type'] }.join("&#124;")}&gt;"
      end
    else 
      result = type
    end
  else
    result = 'any of ' + property_info['anyOf'].map { |t| t['type'] }.to_s if property_info.key?('anyOf')
  end

  "<code>#{result}</code>"
end

def write_properties_doc(properties, required_properties, parent = '')
  content = ''
  properties.each{ |property_name, property_info|
    property_description = ''
    if property_info['description']
      property_description = property_info['description']
    end

    if parent != ''
      content += "#### #{parent}#{property_name}\n\n"
    else
      content += "### #{property_name}\n\n"
    end
    content += "<br/>\n"
    is_required = required_properties.include?(property_name)
    if is_required
      content += "<Badge type='tip' text='required' vertical='bottom' />\n"
    else
      content += "<Badge type='warning' text='optional' vertical='bottom' />\n"
    end

    content += "<br/><br/>\n"
    content += "#{property_description}\n\n"
    content += "- Value type is #{get_property_type(property_info)}\n"
    content += "- The default is `#{property_info['default'] || 'null'}`\n" if !is_required && property_info.key?('default')
    content += "- [Field interpretation](#) is supported for this parameter\n" if property_info['interpreted']
    content += "\n"

    if property_info['type'] == 'object'
      if property_info['anyOf']
        content += "This object contains **any of** the following properties:\n\n"
        property_info['anyOf'].each{|any_of_item| 
          deep_element = any_of_item
          if any_of_item['type'] == 'array'
            deep_element = any_of_item['items']
          end

          content += write_properties_doc(deep_element['properties'], deep_element['required'], "#{parent}#{property_name}.")
        }
      else
        content += "This object contains the following properties:\n\n"
        content += write_properties_doc(property_info['properties'], property_info['required'], "#{parent}#{property_name}.")
      end
    elsif property_info['type'] == 'array' && property_info.key?('items') && property_info['items']['type'] == 'object'
      content += "This array contains objects with the following properties:\n\n"
      content += write_properties_doc(property_info['items']['properties'], property_info['items']['required'], "#{parent}#{property_name}[].")
    end
  }
  content
end

def write_module_doc(type:, title:, output_dir:)
  index_output = "#{output_dir}/index.md"
  index_content = "# #{title}\n\n"
  
  type_description = JSON_DOC['common'][type]['description']
  type_schema = JSON.parse(JSON_DOC['common'][type]['schema']) unless JSON_DOC['common'][type]['schema'].nil?
  index_content += "#{type_description}\n\n"
  index_content += "| Plugin | Description |\n"
  index_content += "|---|---|\n"

  JSON_DOC[type].each{ |plugin_name, plugin_info|
    plugin_output = "#{output_dir}/#{plugin_name}.md"
    plugin_content = "# #{plugin_name} <Badge type='tip' text='#{plugin_info['license']}' vertical='top' />\n\n"
    plugin_content += "## Description\n\n"
    plugin_description = plugin_info['description'].gsub("\n", "<br/>")
    
    if plugin_description
      plugin_content += "#{plugin_description}\n\n"
    end
    
    if plugin_info['details']
      plugin_content += "#{plugin_info['details']}\n\n"
    end
    
    index_content += "| [#{plugin_name}](./#{plugin_name}.md) | #{plugin_description} |\n"
    plugin_content += "## List of parameters\n\n"
    plugin_content += "| Parameter | Description | Type | Default | Required |\n"
    plugin_content += "|---|---|---|---|---|\n"
    
    plugin_schema = plugin_info['schema']
    if plugin_schema
      plugin_schema = JSON.parse(plugin_schema)

      write_properties_to_table = ->(properties, required_properties) {
        properties.each{ |property_name, property_info|
          property_description = ''
          if property_info['description']
            property_description = property_info['description']
            property_description = property_description[0, 100] + '...' if property_description.length > 110
            property_description = property_description.gsub("\n", "<br/>")
          end
  
          is_required = required_properties.include?(property_name)
          required = is_required ? 'Yes' : 'No'
          default = is_required ? '' : property_info['default'] || '`null`'
  
          plugin_content += "| [#{property_name}](##{property_name}) | #{property_description} | #{get_property_type(property_info)} | #{default} | #{required} |\n"
        }
      }

      write_properties_to_table.(COMMON_PLUGIN_SCHEMA['properties'], COMMON_PLUGIN_SCHEMA['required'])
      write_properties_to_table.(type_schema['properties'], type_schema['required']) unless type_schema.nil?
      write_properties_to_table.(plugin_schema['properties'], plugin_schema['required'])
      plugin_content += "\n"
      plugin_content += write_properties_doc(COMMON_PLUGIN_SCHEMA['properties'], COMMON_PLUGIN_SCHEMA['required'])
      plugin_content += write_properties_doc(type_schema['properties'], type_schema['required']) unless type_schema.nil?
      plugin_content += write_properties_doc(plugin_schema['properties'], plugin_schema['required'])
    end

    write_file(plugin_output, plugin_content)
  }

  write_file(index_output, index_content)
end

write_module_doc type: "input", title: "Inputs", output_dir: INPUTS_DOC
write_module_doc type: "output", title: "Outputs", output_dir: OUTPUTS_DOC
write_module_doc type: "extractor", title: "Extractors", output_dir: EXTRACTORS_DOC
write_module_doc type: "transformer", title: "Transformers", output_dir: TRANSFORMERS_DOC
write_module_doc type: "assertion", title: "Assertions", output_dir: ASSERTIONS_DOC
