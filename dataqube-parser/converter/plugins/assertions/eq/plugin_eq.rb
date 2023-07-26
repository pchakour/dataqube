require_relative '../../../core/assertion'

class Eq < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if a field value is equal to a specified value"
  plugin_details """
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-8}
- tag: EXPECTED_TEMPERATURE
  extract:
    - type: grok
      pattern: \"Los Angeles max temperature is %{NUMBER:temperature:int} expected %{NUMBER:expected:int}\"
  assert:
    - type: eq
      source: temperature
      value: \"%{expected:int}\" # Use field interpretation here
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  \"message\": \"Los Angeles max temperature is 68 expected 50\"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{6-16}
{
  \"temperature\": 68,
  \"expected\": 50,
  \"message\": \"Los Angeles max temperature is 68 expected 50\",
  \"_dataqube.tags\": [\"EXPECTED_TEMPERATURE\"],
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXPECTED_TEMPERATURE\",
      \"message\": \"Fields temperature not matching\",
      \"severity\": \"info\",
      \"expected\": \"50\",
      \"value\": \"68\",
      \"status\": \"unresolved\",
      \"id\": \"1dd3d1fa-46eb-4ef0-b02f-1a30f850b7ec\"
    }
  ]
}
```

  </CodeGroupItem>
</CodeGroup>
  """

  desc "Source field to check"
  config_param :source, :string, multi: true
  desc "Value to compare"
  config_param :value, :any, { field_interpretation: true }

  def initialize()
    super("eq")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    value = value(params[:value])
    
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      displayedValue = #{value}
      if !sources.kind_of?(Array)
        sources = [sources]
      end
      sources.each do |field|
        if '#{params[:expected]}' == 'success'
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} not matching"}')
            .expect(record[field])
            .toBe(#{value})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} match"}')
            .expect(record[field])
            .not
            .toBe(#{value})
        end
      end
    }
  end
end