require 'csv'

def parse_csv(text, separator = ';', skip_header = false, skip_empty_rows = false)
  CSV.parse_line(text)
end