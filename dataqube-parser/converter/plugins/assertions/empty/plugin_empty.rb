require_relative '../../../core/assertion'

class Empty < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if a field value is empty"
  plugin_details """
  Empty `string`, `array` and the value `nil` are consider empty by the plugin.

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
    - type: empty
      source: temperatures
      expected: failure # We want the temperatures field not empty
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  \"message\": \"Los Angeles temperatures: []\"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{5-15}
{
  \"temperatures\": [],
  \"message\": \"Los Angeles temperatures: []\",
  \"_dataqube.tags\": [\"EXTRACT_TEMPERATURES\"],
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXTRACT_TEMPERATURES\",
      \"message\": \"Fields temperatures are empty\",
      \"severity\": \"info\",
      \"expected\": \"![\"\", nil, []]\",
      \"value\": \"[]\",
      \"status\": \"unresolved\",
      \"id\": \"803471cc-9b1b-4e15-96c8-1979ec4260fe\"
    }
  ]
}
```

  </CodeGroupItem>
</CodeGroup>
"""

  plugin_config do
    required(:source).array(:str?).description("Source field to check")
  end

  def initialize()
    super("empty")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      if !sources.kind_of?(Array)
        sources = [sources]
      end
      sources.each do |field|
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} are not empty"}')
            .expect(record[field])
            .toBeOneOf('', nil, [])
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} are empty"}')
            .expect(record[field])
            .not
            .toBeOneOf('', nil, [])
        end
      end
    }
  end
end