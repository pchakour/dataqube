require "time"

def parse_timestamp(text, format = nil)
  if text
    real_format = "%Y-%m-%dT%H:%M:%S.%L%z" # iso8601
    if format != nil && format.upcase != 'ISO8601'
      real_format = format
    end

    return Time.strptime(text, real_format).iso8601
  end
end