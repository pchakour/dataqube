def overwrite_target_data(event, data)
  if @target
    event.set(@target, data)
  else
    data.each do |key, value|
      event.set(key, value)
    end
  end
end # def overwrite_target_data

def merge_target_data(event, data)
  if @target
    event_target = event.get(@target)
    if not event_target
      overwrite_target_data(event, data)
    else
      if event_target.is_a?(Hash) && data.is_a?(Hash)
        data = merge_hash(event_target, data)
        event.set(@target, data)
      else
        event.set(@target, [event_target, data])
      end 
    end
  else 
  end
end # def merge_target_data

def merge_hash(hash, data, overwrite=false)
  if !data || data.empty? || !data.is_a?(Hash)
    return hash
  elsif !hash || hash.empty? || !hash.is_a?(Hash)
    return data
  else
    return hash.merge(data) { |key, oldval, newval|
      if oldval.is_a?(Hash) && newval.is_a?(Hash)
        merge_hash(oldval, newval)
      else
        if oldval == newval
          oldval
        elsif overwrite
          newval
        else
          [oldval, newval]
        end
      end
    }
  end
end

def path_field(field)
  field_parts = field.split(']')
  if field_parts.length > 1
    field_parts = field_parts.map {|item| item[1..-1]}
  end
  return field_parts
end
