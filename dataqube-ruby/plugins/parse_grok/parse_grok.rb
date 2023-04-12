require_relative './grok_parser'

$grok_parser = GrokParser.new()
$grok_parser.configure()

def parse_grok(str, pattern)
  $grok_parser.parse(str, pattern)
end

def parse_grok!(str, pattern)
  parser_error_wrapper!(:parse_grok, str, pattern)
end
