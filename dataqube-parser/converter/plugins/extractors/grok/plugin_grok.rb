require_relative '../../../core/extractor'

class Grok < Dataqube::Extractor
  plugin_license "community"
  plugin_desc "Extract informations using grok patterns"
  plugin_details "This plugin assert an error if the extraction process failed depending on the 'expected' parameter"

  desc "Source field on which apply the grok pattern"
  config_param :source, :string, default: 'message'
  desc "EXPLAIN THIS PARAM"
  config_param :target, :string, default: 'message'
  desc "Pattern grok to use. You can specify several patterns to check"
  config_param :pattern, :string, { multi: true }
  desc "Severity error"
  config_param :severity, ['info', 'major', 'minor', 'fatal'], default: 'info'
  desc "Indicate if you expect the check failed or succeed"
  config_param :expected, ['failure', 'success'], default: 'success'
  desc "Change the default merge behavior with overwriting"
  config_param :overwrite, :boolean, default: false

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
      record = merge_hash(record, grok_result, #{params[:overwrite]})
    }
  end

  private

  def quality(rule_tag, params)
    quality_rule = "quality!(record).rule('#{rule_tag}', '#{params[:severity]}', '#{rule_description(params)}').expect(error)"
    if params[:expected] == "failure"
      quality_rule << ".not"
    end
    quality_rule << ".toBe(nil)"
  end

  def rule_description(params)
    if params[:expected] == "failure"
      return "The source #{params[:source]} must not match one of following pattern: #{escape(params[:pattern])}"
    elsif params[:expected] == "success"
      return "The source #{params[:source]} must match one of following patterns: #{escape(params[:pattern])}"
    end
  end
end