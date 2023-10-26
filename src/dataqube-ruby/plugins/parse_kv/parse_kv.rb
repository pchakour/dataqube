def parse_kv(str)
  r = {}
  if !str.nil? && match = str.scan(/\b([A-Za-z]{1,20})=(?:([^\ "][^, ]*)|\"([^\"]+)\"),?/)
    match.each{|m|
      r[m[0]] = m[1].nil? ? m[2] : m[1]
    }
  end
  return r.empty? ? nil : r
end