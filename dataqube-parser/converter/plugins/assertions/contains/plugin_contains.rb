require_relative '../../../core/assertion'

class Contains < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if an array contains a specific value"
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-12}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
  assert:
    - type: contains
      source: temperatures
      value: 50
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

```json{5-15}
{
  \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\",
  \"temperatures\": [64, 65, 67, 67, 65, 65, 66],
  \"_dataqube.tags\": [\"EXTRACT_TEMPERATURES\"],
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXTRACT_TEMPERATURES\",
      \"message\": \"Field temperatures must contain 50\",
      \"severity\": \"info\",
      \"expected\": \"50\",
      \"value\": \"[64, 65, 67, 67, 65, 65, 66]\",
      \"status\": \"unresolved\",
      \"id\": \"641b49e6-449e-4fbc-bd98-25829d77c3fc\"
    }
  ]
}
```

  </CodeGroupItem>
</CodeGroup>
"""

  desc "Source field to check. The field must be an array."
  config_param :source, :string
  desc "Value to find in the array"
  config_param :value, :any, { field_interpretation: true }

  def initialize()
    super("contains")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    value = escape(value(params[:value]))

    %{
      if #{record(params[:source])}.kind_of?(Array)
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Field #{params[:source].to_s} must contain #{value}"}')
            .expect(#{record(params[:source])})
            .toContain(#{value(params[:value])})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Field #{params[:source].to_s} must not contain #{value}"}')
            .expect(#{record(params[:source])})
            .not
            .toContain(#{value(params[:value])})
        end
      end
    }
  end
end