require_relative './grok_parser'
require_relative '../../lib/parser/parser_error_wrapper'

$grok_parser = GrokParser.new()
$grok_parser.configure()

def parse_grok(str, pattern)
  $grok_parser.parse(str, pattern)
end

def parse_grok!(str, pattern)
  parser_error_wrapper!(:parse_grok, str, pattern)
end
