require_relative '../../../core/assertion'

class Size < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if the size of an array is include between a min and a max. Min and max are included."
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-13}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
  transform:
    - type: list
      source: temperatures
      overwrite: true
  assert:
    - type: size
      source: temperatures
      min: 1
      max: 5
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 68]\"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{5-15}
{
  \"temperatures\": [64, 65, 67, 67, 65, 68],
  \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 68]\",
  \"_dataqube.tags\": [\"EXTRACT_TEMPERATURES\"],
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXTRACT_TEMPERATURES\",
      \"message\": \"Fields temperatures size must be between or equal to 1 and 5\",
      \"severity\": \"info\",
      \"expected\": \"[1, 5]\",
      \"value\": \"6\",
      \"status\": \"unresolved\",
      \"id\": \"9587b5e6-4cb7-4f09-8b70-11577673dee1\"
    }
  ]
}
```

  </CodeGroupItem>
</CodeGroup>
"""

  desc "Source field to check. The field must be an array."
  config_param :source, :string
  desc "Min value"
  config_param :min, :integer, default: 0
  desc "Max value"
  config_param :max, :integer, default: 0

  def initialize()
    super("size")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    min = value(params[:min])
    max = value(params[:max])
    %{
      if #{record(params[:source])}.kind_of?(Array)
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} size must be between or equal to #{min} and #{max}"}')
            .expect(#{record(params[:source])}.size)
            .toBeBetweenOrEqual(#{min}, #{max})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} size must be between or equal to #{min} and #{max}"}')
            .expect(#{record(params[:source])}.size)
            .not
            .toBeBetweenOrEqual(#{min}, #{max})
        end
      end
    }
  end
end