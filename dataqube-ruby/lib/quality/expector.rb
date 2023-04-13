class Expector
  attr_reader :not
  def initialize(value, record, rescue_error, rule_tag = :unknown, rule_message)
    @value = value
    @record = record
    @rescue_error = rescue_error
    @rule_tag = rule_tag
    @rule_message = rule_message
    @not = false
  end

  public
  def not
    @not = true
    self
  end

  def toBeOneOf(*args)
    index = 0
    args.each do |arg|
      if (arg == @value)
        break
      end

      index = index + 1
    end

    error = index > args.size - 1
    if (@not)
      error = !error
    end
    
    if (error)
      @expected = args.to_s
      stamp()
      error = "Expected one of #{@expected != nil ? @expected : "nil"} to #{@not ? 'not ' : ''}be #{@value != nil ? @value : "nil"}"
      if @rescue_error
        return @error
      else
        raise error
      end
    end
  end

  def toBe(expected)
    @expected = expected
    condition = @expected == @value
    if (@not)
      condition = !condition
    end

    if (!condition)
      stamp()
      error = "Expected #{@expected != nil ? @expected : "nil"} to #{@not ? 'not ' : ''}be #{@value != nil ? @value : "nil"}"
      if @rescue_error
        return @error
      else
        raise error
      end
    end
  end

  def toBeDefined()
  end

  def toBeBetweenOrEqual(min, max)
    @expected = "[#{min}, #{max}]"
    condition =  @value >= min && @value <= max
    if (@not)
      condition = !condition
      @expected = "!#{@expected}"
    end

    if (!condition)
      stamp()
      error = "Expected #{@value} to #{@not ? 'not ' : ''}be between or equal to #{min} and #{max}"
      if @rescue_error
        return @error
      else
        raise error
      end
    end
  end

  def toBeGreaterThan(number)
  end
  
  def toBeGreaterThanOrEqual(number)
  end

  def toBeLessThan(number)
  end

  def toBeGreaterThanOrEqual(number)
  end

  def toContainKey(key)
  end

  def toContain(expected)
    @expected = expected
    condition = @value.include?(expected)
    if (@not)
      condition = !condition
      @expected = "!#{@expected}"
    end

    if (!condition)
      stamp()
      error = "Expected #{@value} to #{@not ? 'not ' : ''}contain #{@expected}"
      if @rescue_error
        return @error
      else
        raise error
      end
    end
  end

  private
  def stamp()
    if !@record['_dataqube.quality']
      @record['_dataqube.quality'] = []
    end

    
    quality_stamp = {}

    if @rule_tag
      quality_stamp[:tag] = @rule_tag
    end

    if @rule_message
      quality_stamp[:message] = @rule_message
    end
    
    quality_stamp[:expected] = @not ? "!#{@expected.to_s}" : @expected.to_s
    quality_stamp[:value] = "#{@value.to_s}"
    @record['_dataqube.quality'].push(quality_stamp)
  end
end