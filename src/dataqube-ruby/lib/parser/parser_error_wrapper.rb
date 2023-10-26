def parser_error_wrapper!(parser, *args)
  error = nil
  result = {}
  begin
    result = method(parser).call(*args)
  rescue => e
    error = e
  end

  return result, error
end