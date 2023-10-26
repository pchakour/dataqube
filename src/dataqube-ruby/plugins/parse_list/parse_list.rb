require_relative './list_parser'

$list_parser = ListParser.new()

def parse_list(str)
  $list_parser.parse(str)
end