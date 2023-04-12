class Grok
  class GrokPatternNotFoundError < StandardError
  end

  # Much of the Grok implementation is based on Jordan Sissel's jls-grok
  # See https://github.com/jordansissel/ruby-grok/blob/master/lib/grok-pure.rb
  GROK_PATTERN_RE = \
      /%\{    # match '%{' not prefixed with '\'
          (?<name>     # match the pattern name
            (?<pattern>[A-z0-9]+)
            (?::(?<subname>[@\[\]A-z0-9_:.-]+?)
                (?::(?<type>(?:string|bool|integer|int|float|
                                time(?::.+?)?|
                                array(?::.)?)))?)?
          )
        \}/x
    #'

  attr_reader :parsers
  attr_reader :multiline_start_regexp

  def initialize()
    @pattern_map = {}
    @parsers = {}
    @multiline_mode = false
    @time_format = nil
    @timezone = nil
    @keep_time_key = true
  end

  def add_patterns_from_file(path)
    File.open(path, "r:utf-8:utf-8").each_line do |line|
      next if line[0] == "#" || /^$/ =~ line
      name, pat = line.chomp.split(/\s+/, 2)
      @pattern_map[name] = pat
    end
  end

  def expand(grok_pattern)
    regexp, types, ecs_fields = expand_grok_pattern(grok_pattern)
    $log.info "Expanded the pattern #{grok_pattern} into #{regexp}"
    parser = Regexp.new(regexp)
    @parsers[grok_pattern] = [parser, ecs_fields]
  rescue GrokPatternNotFoundError => e
    raise e
  rescue => e
    $log.error(error: e)
    nil
  end

  private

  def expand_grok_pattern(pattern)
    # It's okay to modify in place. no need to expand it more than once.
    type_map = {}
    ecs_fields = []
    while true
      m = GROK_PATTERN_RE.match(pattern)
      break unless m
      curr_pattern = @pattern_map[m["pattern"]]
      raise GrokPatternNotFoundError, "grok pattern not found: #{m["pattern"]}" unless curr_pattern
      if m["subname"]
        ecs = /(?<ecs-key>(^\[.*\]$))/.match(m["subname"])
        subname = if ecs
                    # remove starting "[" and trailing "]" on matched data
                    ecs["ecs-key"][1..-2].split("][").join('.')
                  else
                    m["subname"]
                  end
        if ecs
          ecs_fields.append(subname)
        end

        replacement_pattern = "(?<#{subname}>#{curr_pattern})"
        type_map[subname] = m["type"] || "string"
      else
        replacement_pattern = "(?:#{curr_pattern})"
      end
      pattern = pattern.sub(m[0]) do |s|
        replacement_pattern
      end
    end

    [pattern, type_map, ecs_fields]
  end
end