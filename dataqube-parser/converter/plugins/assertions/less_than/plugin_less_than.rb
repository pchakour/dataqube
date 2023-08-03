require_relative '../../../core/assertion'

class LessThan < Dataqube::Assertion
  plugin_license "community"
  plugin_desc "Check if a field value is less than a specified value"
  plugin_details """
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-8}
- tag: EXPECTED_TEMPERATURE
  extract:
    - type: grok
      pattern: \"Los Angeles max temperature is %{NUMBER:temperature:int}\"
  assert:
    - type: less_than
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
      \"message\": \"Fields temperature must be less than 70\",
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

  plugin_config do
    required(:source).array(:string).description("Source field to check")
    required(:value){ array? & each{ int? | str?}}
      .isInterpreted
      .description("Value to compare")
  end

  def initialize()
    super("less_than")
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
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} must be less than #{escape(value)}"}')
            .expect(record[field])
            .toBeLessThan(#{value})
        else
          quality!(record)
            .rule('#{rule_tag}', '#{params[:severity]}', '#{params[:message] || "Fields #{params[:source].to_s} must not be less than #{escape(value)}"}')
            .expect(record[field])
            .not
            .toBeLessThan(#{value})
        end
      end
    }
  end
end