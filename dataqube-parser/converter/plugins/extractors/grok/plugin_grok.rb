require_relative '../../../core/extractor'

class Grok < Dataqube::Extractor
  config_param :source, :string, default: 'message'
  config_param :expected, :string, default: 'success'
  config_param :pattern, :string, { multi: true }

  def initialize()
    super("grok")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    patterns = params[:pattern]
    if !patterns.kind_of?(Array)
      patterns = [patterns]
    end

    break_condition = "!error"
    if params[:expected] == "failure"
      break_condition = "error"
    end

    %{
      patterns = #{patterns.to_s.gsub('"', "'")}
      grok_result = nil
      error = nil
      patterns.each{|pattern|
        grok_result, error = parse_grok!(#{record(params[:source])}, pattern)
        if #{break_condition}
          break
        end
      }
      #{quality(rule_tag, params)}
      record = merge_hash(record, grok_result)
    }
  end

  private

  def quality(rule_tag, params)
    quality_rule = "quality!(record).rule('#{rule_tag}', '#{rule_description(params)}').expect(error)"
    if params[:expected] == "failure"
      quality_rule << ".not"
    end
    quality_rule << ".toBe(nil)"
  end

  def rule_description(params)
    if params[:expected] == "failure"
      return "The source #{params[:source]} must not match one of following pattern: #{params[:pattern].to_s.gsub('"', "\\\\\\\\'")}"
    elsif params[:expected] == "success"
      return "The source #{params[:source]} must match one of following patterns: #{params[:pattern].to_s.gsub('"', "\\\\\\\\'")}"
    end
  end
end