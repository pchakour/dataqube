require 'yaml'

class Config
  attr_reader :content

  def initialize()
  end

  def start(config_path, injection_id, rules)
    load(config_path)

    if !injection_id.nil?
      if !rules.nil?
        @content['rules'] = rules
      end

      dataqube_output = @content['outputs'].find {|output| output['type'] == 'dataqube'}
      dataqube_output['type'] = 'elasticsearch'
      dataqube_output['index'] = "data-#{injection_id}"
    end

    resolveIncludes()
  end

  private

  def  resolveIncludes() 
    if @content.key?('rules')
      value_to_replace = []
      @content['rules'].each_with_index { |rule, index| 
        if rule.key?('include')
          file_path = rule['include']
          include_content = YAML.load_file(file_path)

          if include_content.key?('rules')
            value_to_replace.push({
              'content' => include_content['rules'],
              'index' => index
            })
          end
        end
      }

      value_to_replace.each { |replacement|
        replacement['content'].each_with_index { |replacement_content, index| 
          current_index = replacement['index'] + index
          if current_index == 0
            @content['rules'][current_index] = replacement_content
          else
            @content['rules'].insert(current_index, replacement_content)
          end
        }
      }
    end
  end

  def load(config_path)
    puts "Reading config file " + config_path
    @content = YAML.load_file(config_path)

    if !@content.key?('rules')
      @content['rules'] = []
    end
  end
end