require_relative './expector'

class Quality
  def initialize(record, rescue_error)
    @record = record
    @rescue_error = rescue_error
    @rule_tag = nil
    @rule_message = ""
    @severity = 'info'
  end

  def rule(rule_tag, severity, rule_message)
    @rule_tag = rule_tag
    @rule_message = rule_message
    @severity = severity
    self
  end

  def expect(value)
    Expector.new(value, @record, @rescue_error, @rule_tag, @rule_message, @severity)
  end
end