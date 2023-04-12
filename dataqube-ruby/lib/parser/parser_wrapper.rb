def parser_wrapper!(parser, *args)
  error = nil
  result = {}
  begin
    result = method(parser).call(*args)
  rescue => e
    puts 'NIQUE TAMERE ' + e.to_s
    error = e
  end

  return result, error
end

def parser_wrapper(parser, *args)
  method(parser).call(*args)
end