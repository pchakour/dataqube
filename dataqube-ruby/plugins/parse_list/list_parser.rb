# Constants used for transform check
TYPE_QUOTED_STRING = "quoted_string"
TYPE_NUMBER = "number"
TYPE_OBJECT = "object"
TYPE_DATE = "date"
TYPE_KEY_VALUE = "key_value"
TYPE_LIST = "list"
TYPE_INTEGER = "integer"
TYPE_FLOAT = "float"
TYPE_UNKNOWN = "unknown"

class ListParser

  # config :source, :validate => :string, :default => "message"
  # config :target, :validate => :string
  # config :type, :validate => [TYPE_QUOTED_STRING, TYPE_NUMBER, TYPE_DATE, TYPE_KEY_VALUE, TYPE_OBJECT]
  # config :overwrite_target, :validate => :boolean, :default => true
  # config :tag_on_failure, :validate => :string, :default => "_listparsefailure"

  def initialize()
    @field_split_re = /,\s(?=[^\]]*(?:\[|$))(?=[^\}]*(?:\{|$))/
    @date_iso_re = /(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.\d+)|(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d)|(\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d)/
  end


  public

  def parse(data, type=nil)
    if !data
      return {}
    end

    if data[0] == '[' && data[-1] == ']'
      data[0] = ''
      data[-1] = ''
    end

    data = data.split(@field_split_re)
    unless type
      type = detect_type(data[0])
    end

    case type
    when TYPE_KEY_VALUE
      return parse_key_value_list(data)
    else
      return parse_data(data)
    end
  end # def parse 

  private 

  def parse_data(data)
    parsed_data = []
    data.each do |value|
      parsed_data.push(convert_type(value))
    end
    return parsed_data
  end # def parse_quoted_string

  def parse_key_value_list(data)
    parsed_data = {}
    merged_key = {}
    data.each do |value|
      kv = parse_key_value(value)
      if parsed_data[kv[0]]
        if not merged_key[kv[0]]
          merged_key[kv[0]] = true
          mem = parsed_data[kv[0]]
          parsed_data[kv[0]] = []
          parsed_data[kv[0]].push(mem)
        end
        parsed_data[kv[0]].push(kv[1])
      else
        parsed_data[kv[0]] = kv[1]
      end
    end
    return parsed_data
  end # def parse_key_value_list

  def parse_key_value(value)
    kv = value.split('=', 2)
    kv[1] = convert_type(kv[1])

    return kv
  end # def parse_key_value

  def detect_type(value)
    if value.nil?
    	return TYPE_UNKNOWN
    end
    if is_surrounded_by?(value, '"') or is_surrounded_by?(value, "'")
      return TYPE_QUOTED_STRING
    elsif is_surrounded_by?(value, '[', ']')
      return TYPE_LIST
    elsif is_surrounded_by?(value, '{', '}')
      return TYPE_OBJECT
    elsif (value.match(@date_iso_re))
        return TYPE_DATE
    elsif (value.include?('='))
      return TYPE_KEY_VALUE
    elsif (value.include?(',') or value.include?('.'))
        begin
            Float(value)
            return TYPE_FLOAT
        rescue
            return TYPE_UNKNOWN
        end
    else
        begin
            Integer(value)
            return TYPE_INTEGER
        rescue
            return TYPE_UNKNOWN
        end
    end
  end # def detect_type

  def is_surrounded_by?(value, start_character, end_character=nil)
    if end_character
      return value[0] == start_character && value[-1] == end_character
    else
      return value[0] == start_character && value[-1] == start_character
    end
  end # def is_surrounded_by?

  def convert_type(value)
    type = detect_type(value)
    #puts "Type #{type} for value #{value}"
    case type
    when TYPE_QUOTED_STRING
      quoted_string = value
      quoted_string[0] = ''
      quoted_string[-1] = ''
      return quoted_string
    when TYPE_LIST
      return parse(value)
    when TYPE_OBJECT
      begin
        return JSON.parse(value)
      rescue => e
        return parse(value[1..-2].strip!)
      end
    when TYPE_DATE
      return DateTime.parse(text, 'iso8601')
    when TYPE_FLOAT
      return Float(value)
    when TYPE_INTEGER
      return Integer(value)
    when TYPE_UNKNOWN
      return value
    else
      return value
    end
  end # def convert_type

end