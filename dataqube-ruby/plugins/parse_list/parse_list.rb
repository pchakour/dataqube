require_relative './list_parser'

_list_parser = ListParser.new()

def parse_list(str)
  _list_parser.parse(str)
end