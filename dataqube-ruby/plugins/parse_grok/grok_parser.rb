require_relative 'grok'
require_relative '../../lib/utils'

class GrokParser

  def initialize()
    @grok_pattern_series = :legacy
  end

  def configure()
    @grok = Grok.new()
    default_pattern_dir = File.expand_path("patterns/#{@grok_pattern_series}/*", File.dirname(__FILE__))
    Dir.glob(default_pattern_dir) do |pattern_file_path|
      @grok.add_patterns_from_file(pattern_file_path)
    end
  end

  def parse(text, pattern)
    if !@grok.parsers.key?(pattern)
      @grok.expand(pattern)
    end 

    parser, ecs_fields = @grok.parsers[pattern]
    match = parser.match(text)
    if !match
      raise 'Grok parse failure'
    end

    return dotSplit(match.named_captures, ecs_fields)
  end

  def dotSplit(hash, ecs_fields)
    if ecs_fields.empty?
      return hash
    end
    
    splitted = hash.dup
    fields = ecs_fields.dup
    hash.each {|key, value|
      if fields.include?(key)
        key_parts = key.split('.')
        fields.delete(key)
        
        if key_parts.length > 1
          last_key = key_parts[-1]
          new_key = key_parts[0..-2].join('.')
          new_value = {}
          new_value[last_key] = value
          splitted[new_key] = merge_hash(splitted[new_key], new_value)
          splitted.delete(key)
          fields.push(new_key)
        end
      end
    }

    return dotSplit(splitted, fields)
  end
end