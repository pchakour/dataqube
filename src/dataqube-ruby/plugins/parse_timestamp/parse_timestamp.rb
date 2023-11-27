require "date"

def parse_timestamp(text, format = nil)
  if text
    if format && format != 'iso8601'
      return DateTime.strptime(text, format).iso8601
    end

    return DateTime.parse(text).iso8601
  end
end

def parse_timestamp!(text, format = nil)
  parser_error_wrapper!(:parse_timestamp, text, format)
end