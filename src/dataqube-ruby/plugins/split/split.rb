require_relative '../../lib/utils'

def split(record, fields)
  records = [record]
  fields.each {|field|
    new_records = []
    path = path_field(field)
    records.each{|current_record|
      value = current_record.dig(*path)
      serialized = Marshal.dump(current_record)
      if value && value.kind_of?(Array)
        value.each{|splitted|
          new_record =  Marshal.load(serialized)
          key_to_set = new_record
          path[0..-2].each{|step|
            key_to_set = key_to_set[step]
          }
          key_to_set[path[-1]] = splitted
          new_records.append(new_record)
        }
      else
        new_record =  Marshal.load(serialized)
        new_records.append(new_record)
      end
    }
    records = new_records
  }
  return records
end