require 'fluent/plugin/filter'
require 'dataqube-ruby'

module Fluent::Plugin
  class DataqubeFilter < Filter
    # Register this filter as "passthru"
    Fluent::Plugin.register_filter('dataqube', self)
    
    # config_param works like other plugins
    desc "Init code to execute a startup"
    config_param :init, :string, default: nil
    
    desc "Code to execute for each data injection"
    config_param :code, :string, default: nil
    
    def configure(conf={})
      super
      
      # Do the usual configuration here
      configure_ruby()
      
      code = parse_multiline_code(@init)
      self.instance_eval(code, binding)
    end

    # def start
    #   super
    #   # Override this method if anything needed as startup.
    # end
    
    # def shutdown
    #   # Override this method to use it to free up resources, etc.
    #   super
    # end
    
    def filter_stream(tag, es)
      new_es = Fluent::MultiEventStream.new
      es.each { |time, record|
        new_records = process_record(tag, time, record)
        if !new_records.kind_of?(Array)
          new_records = [new_records]
        end
        
        new_records.each { |new_record|
          if new_record
            new_es.add(time, new_record)
          end
        }
      }
      return new_es
    end
    
    private
    
    def process_record(tag, time, record)
      code = parse_multiline_code(@code)
      self.instance_eval(code, binding, 'parser_config', 0)
    end
    
    def parse_multiline_code(code)
      parsed_code = code.clone;
      if parsed_code[0,2] == '${' && parsed_code[-1] == '}'
        parsed_code = parsed_code[2..-2]
      end

      return parsed_code
    end
  end
end