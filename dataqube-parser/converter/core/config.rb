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
  end

  private

  def load(config_path)
    puts "Reading config file " + config_path
    @content = YAML.load_file(config_path)
  end
end