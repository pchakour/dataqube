require_relative '../../../core/assertion'

class Lower < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if a field value is lower than a specified value"
  plugin_details """
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-8}
- tag: EXPECTED_TEMPERATURE
  extract:
    - type: grok
      pattern: \"Los Angeles max temperature is %{NUMBER:temperature:int}\"
  assert:
    - type: lower
      source: temperature
      value: 70
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  \"message\": \"Los Angeles max temperature is 71\"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{6-16}
{
  \"temperature\": 68,
  \"expected\": 50,
  \"message\": \"Los Angeles max temperature is 71\",
  \"_dataqube.tags\": [\"EXPECTED_TEMPERATURE\"],
  \"_dataqube.quality\": [
    {
      \"tag\": \"EXPECTED_TEMPERATURE\",
      \"message\": \"Fields temperature must be lower than 70\",
      \"severity\": \"info\",
      \"expected\": \"70\",
      \"value\": \"71\",
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
    super("lower")
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
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} must be lower than #{escape(value)}"}')
            .expect(record[field])
            .toBe(#{value})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} must not be lower than #{escape(value)}"}')
            .expect(record[field])
            .not
            .toBe(#{value})
        end
      end
    }
  end
end