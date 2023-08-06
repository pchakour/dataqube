require_relative '../../../core/extractor'

class Grok < Dataqube::Extractor
  plugin_license "community"
  plugin_desc "Extract informations using grok patterns"
  plugin_details """
::: warning
This plugin assert an error if the extraction process failed depending on the match result and the [expected](#expected) parameter.
:::

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
"""

  plugin_config do
    optional(:source)
      .filled(:string)
      .default('message')
      .description("Source field on which apply the grok pattern")

    required(:pattern){ filled? & (str? | (array? & str?)) }
      .description("""
Pattern grok to use. You can specify several patterns to check.

The pattern can use typing for a field to convert the value to a string, an integer or a float.

Example to convert as an integer:

`%{NUMBER:name:int}`

or

`%{NUMBER:name:integer}`

The field support structure naming to create structured fields in your event.

`%{LOGLEVEL:[log][level]}`

will create the following event

`{ log: { level: 'info' }}`

The field name support also the use of `@metadata` structure to store temporary data.
`@metadata` are kept if the event has an assertion.

`%{NUMBER:[@metadata][name]}`
        """)

    optional(:severity)
      .filled(:string, included_in?: ['info', 'major', 'minor', 'fatal'])
      .default('info')
      .description("Severity error")

    optional(:expected)
      .filled(:string, included_in?: ['failure', 'success'])
      .default('success')
      .description("Indicate if you expect the check failed or succeed")

    optional(:overwrite)
      .filled(:bool)
      .default(false)
      .description("Change the default merge behavior with overwriting")
  end

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