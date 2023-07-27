module Dataqube
  class Plugin
    attr_reader :plugin_type
    attr_reader :name
    attr_writer :logger


    desc "List of tag to add if the plugin is well executed"
    config_param :tag, :string, { multi: true, default: nil }
    desc "Ruby predicate to indicate when execute this plugin"
    config_param :when, :string, default: nil

    def initialize(plugin_type, name)
      @name = name
      @plugin_type = plugin_type
    end

    def convert(convertor_name, rule_tag, params)
      fail NotImplementedError, "A plugin must implement the convert method"
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
        value.scan(/.*%\{(.*)\}[^%\{]*/).each {|match|
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
          new_value = replace_except_first_occurrence_with_regex(new_value, /record\[/, "' + \\0")

          if !new_value.start_with?(records[0][0])
            new_value = "'" + new_value
          end

          if !new_value.end_with?(records[records.length - 1][0])
            new_value = new_value + "'"
          end

          records.each{|value|
            record = value[0]
            type = value[1]

            conversion = 'to_s'
            if type == 'int' || type == 'integer'
              conversion = 'to_i'
            elsif type == 'float'
              conversion = 'to_f'
            end
            new_value = new_value.sub(record, "\\0.#{conversion}")
          }
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

    def replace_except_first_occurrence_with_regex(input_string, regex_to_replace, replacement)
      first_match = input_string.match(regex_to_replace)
      if first_match
        first_occurrence = first_match[0]
        modified_string = input_string.sub(first_occurrence, '') # Remove the first occurrence
        modified_string.gsub!(regex_to_replace, replacement) # Replace other occurrences
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