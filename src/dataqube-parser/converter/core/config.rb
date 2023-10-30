require 'yaml'

class Config
  attr_reader :content

  def initialize()
  end

  def start(config_path, injection_id, rules)
    load(config_path)

    puts "HELLO"
    puts injection_id

    if !injection_id.nil?
      if !rules.nil?
        @content[:rules] = rules
      end

      # Todo extract this to plugin dataqube_app
      dataqube_output = @content[:outputs].find {|output| output[:type] == 'dataqube_app'}
      dataqube_output[:type] = 'opensearch'
      dataqube_output[:index] = "data-#{injection_id}"
    end

    @content = resolveIncludes(@content, config_path)
  end

  private

  def deep_symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = key.is_a?(String) ? key.to_sym : key
      new_value = value
      new_value = deep_symbolize_keys(value) if value.is_a?(Hash)
      new_value = value.map { |v| v.is_a?(Hash) ? deep_symbolize_keys(v) : v } if value.is_a?(Array)
      result[new_key] = new_value
    end
  end

  def resolveIncludes(config_content, config_path) 
    puts "Resolve includes"
    if config_content.key?(:rules)
      config_dirname = File.dirname(config_path)
      value_to_replace = []
      config_content[:rules].each_with_index { |rule, index| 
        if rule.key?(:include)
          file_path = File.expand_path(rule[:include], config_dirname)
          include_content = YAML.load_file(file_path)
          include_content = deep_symbolize_keys(include_content)
          include_content = resolveIncludes(include_content, file_path)
          if include_content.key?(:rules)
            value_to_replace.push({
              'content' => include_content[:rules],
              'index' => index
              })
          end
        end
      }
        
      value_to_replace.each { |replacement|
        replacement['content'].each_with_index { |replacement_content, index| 
          current_index = replacement['index'] + index
          if current_index == 0
            config_content[:rules][current_index] = replacement_content
          else
            config_content[:rules].insert(current_index, replacement_content)
          end
        }
      }
    end

    config_content
  end

  def load(config_path)
    puts "Reading config file " + config_path
    @content = YAML.load_file(config_path)

    if !@content.key?('rules')
      @content['rules'] = []
    end

    @content = deep_symbolize_keys(@content)
  end
end