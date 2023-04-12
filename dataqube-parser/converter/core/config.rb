require 'yaml'

class Config
  attr_reader :content

  def initialize()
  end

  def start(config_path, project, rules)
    load(config_path)

    if !project.nil?
      if !rules.nil?
        @content['rules'] = rules
      end

      dataqube_output = @content['outputs'].find {|output| output['type'] == 'dataqube'}
      dataqube_output['type'] = 'elasticsearch'
      dataqube_output['index'] = "data-#{project['id']}"
    end
  end

  private

  def load(config_path)
    puts "Reading config file " + config_path
    @content = YAML.load_file(config_path)
  end
end