module Dataqube
  class Plugin
    attr_reader :plugin_type
    attr_reader :name
    attr_writer :logger
    config_param :tag, :string, { multi: true, default: nil }
    config_param :when, :string, default: nil

    def initialize(plugin_type, name)
      @name = name
      @plugin_type = plugin_type
    end

    def convert(convertor_name, rule_tag, params)
      fail NotImplementedError, "A plugin must implement the convert method"
    end

    protected

    def value(value)
      # %{field}
      new_value = value

      if value.kind_of?(String)
        value.scan(/.*%\{(.*)\}[^%\{]*/).each {|match|
          match.each {|field|
            new_value.sub("%{#{field}}", record(field))
          }
        }

        new_value = "'#{new_value}'"
      end

      return new_value
    end

    def record(field)
      "record['#{path_field(field).join("']['")}']"
    end

    def record_key?(field)
      if !field
        return "false"
      end
      path = path_field(field)
      return "record.dig(#{path.join(', ')})"
    end

    def record_delete(_field)
      fields = _field
      if !fields.kind_of?(Array)
        fields = [_field]
      end

      record_deletes = ""
      fields.each {|field|
        path = path_field(field)
  
        if path.length == 1
          record_deletes << "\nrecord.delete(#{field})"
        end
  
        record_deletes << "\nrecord['#{path[0..-2].join("']['")}'].delete('#{path[-1]}')"
      }

      return record_deletes
    end

    private

    def path_field(field)
      field_parts = field.split(']')
      if field_parts.length > 1
        field_parts = field_parts.map {|item| item[1..-1]}
      end
      return field_parts
    end
  end
end