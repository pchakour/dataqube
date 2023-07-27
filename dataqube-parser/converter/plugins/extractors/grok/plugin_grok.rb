require_relative '../../../core/extractor'

class Grok < Dataqube::Extractor
  plugin_license "community"
  plugin_desc "Extract informations using grok patterns"
  plugin_details """
This plugin assert an error if the extraction process failed depending on the match result and the [expected](#expected) parameter.

This is a case where everything is going well.

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{3-4}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
```

</CodeGroupItem>
<CodeGroupItem title='EVENT'>

```json
{
\"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\"
}
```

</CodeGroupItem>
<CodeGroupItem title='OUTPUT'>

```json{3}
{
\"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\",
\"temperatures\": [64, 65, 67, 67, 65, 65, 66],
\"_dataqube.tags\": [\"EXTRACT_TEMPERATURES\"]
}
```

</CodeGroupItem>
</CodeGroup>

This is an another example where the plugin assert an error:

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{3-6}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
      # We expect that the grok failed, but the grok will match correctly so the plugin will assert an error
      expected: failure 
```

</CodeGroupItem>
<CodeGroupItem title='EVENT'>

```json
{
\"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\"
}
```

</CodeGroupItem>
<CodeGroupItem title='OUTPUT'>

```json{3-12}
{
  \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\",
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXTRACT_TEMPERATURES\",
      \"message\": \"The source message must not match one of following pattern: Los Angeles temperatures: %{GREEDYDATA:temperatures}\",
      \"severity\": \"info\",
      \"expected\": \"!\",
      \"value\": \"\",
      \"status\": \"unresolved\",
      \"id\": \"9f0a5c9d-3622-440b-82d5-f7b81665d14d\"
    }
  ],
  \"temperatures\": \"[64, 65, 67, 67, 65, 65, 66]\"
}
```

</CodeGroupItem>
</CodeGroup>


"""

  desc "Source field on which apply the grok pattern"
  config_param :source, :string, default: 'message'
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