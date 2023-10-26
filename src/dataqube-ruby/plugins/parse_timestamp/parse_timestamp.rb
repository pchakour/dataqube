require "date"

def parse_timestamp(text, format = nil)
  if text
    if format
      return DateTime.strptime(text, format).iso8601
    end

    # if format == nil || format.upcase == 'ISO8601'
    #   real_format = "%Y-%m-%dT%H:%M:%S.%L%z" # iso8601

    # end

    return DateTime.parse(text).iso8601
  end
end

def parse_timestamp!(text, format = nil)
  parser_error_wrapper!(:parse_timestamp, text, format)
end