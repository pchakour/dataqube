module Dataqube
  class Plugin
    attr_reader :plugin_type
    attr_reader :name
    attr_writer :logger


    plugin_config do
      optional(:when)
        .filled(:string)
        .description("Ruby predicate to indicate when execute this plugin")
    end

    def initialize(plugin_type, name)
      @name = name
      @plugin_type = plugin_type
    end

    def convert(convertor_name, rule_tag, params)
      fail NotImplementedError, "A plugin must implement the convert method"
    end

    def convertType(type)
      conversion = 'to_s'
      if type == 'int' || type == 'integer'
        conversion = 'to_i'
      elsif type == 'float'
        conversion = 'to_f'
      end
      return conversion
    end

    protected

    def escape(value)
      new_value = value.to_s
      return new_value.gsub("'", "\\\\\\\\'").gsub('"', "\\\\\\\\'")
    end

    def value(value)
      # %{field}
      new_value = value
      records = []
      if value.kind_of?(String)
        value.scan(/%\{([^%\{]*)\}/).each {|match|
          match.each {|interpretation|
            parts = interpretation.split(':')
            field = parts[0]
            type = parts.length > 1 ? parts[1] : 'string'
            _record = record(field)
            records.push([_record, type])
            new_value = new_value.sub("%{#{interpretation}}", _record)
          }
        }
      
        if records.length > 0
          new_value = new_value.gsub!(/record\[[^\]]+\]/, "' + \\0.#{convertType(records.shift()[1])} + '")
          if new_value.start_with?("' + ")
            new_value = new_value["' + ".length..-1]
          else
            new_value = "'" + new_value
          end

          if new_value.end_with?(" + '")
            new_value = new_value[0..(" + '".length) * -1]
          else
            new_value = new_value + "'"
          end
        else
          return "'#{new_value}'"
        end
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
      print fields
      fields.each {|field|
        path = path_field(field)
        puts path
        if path.length == 1
          record_deletes << "\nrecord.delete('#{field}')"
        else
          record_deletes << "\nrecord['#{path[0..-2].join("']['")}'].delete('#{path[-1]}')"
        end
      }

      return record_deletes
    end

    private

    def replace_except_first_occurrence_with_regex(input_string, regex_to_replace, replacement)
      first_match = input_string.match(regex_to_replace)
      if first_match
        first_occurrence = first_match[0]
        modified_string = input_string.sub(first_occurrence, '') # Remove the first occurrence
        puts 'modified string = ' + modified_string
        puts 'first_occurrence string = ' + first_occurrence
        modified_string.gsub!(regex_to_replace, replacement) # Replace other occurrences
        puts 'modified string = ' + modified_string
        modified_string = first_occurrence + modified_string # Add back the first occurrence
        return modified_string
      end
    
      # If no match found, return the original string.
      input_string
    end

    def path_field(field)
      field_parts = field.split(']')
      if field_parts.length > 1
        field_parts = field_parts.map {|item| item[1..-1]}
      end
      return field_parts
    end
  end
end