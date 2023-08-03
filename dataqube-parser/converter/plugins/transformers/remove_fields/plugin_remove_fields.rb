require_relative '../../../core/transformer'

class RemoveFields < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Remove fields from an event"
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{3-5}
- tag: EXAMPLE_REMOVE_FIELD
  transform:
    - type: remove_fields
      source:
        - temperatures
        - other_field
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

  ```json
  {
    \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\",
    \"temperatures\": [64, 65, 67, 67, 65, 65, 66],
    \"other_field\": \"other_value\"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{5-15}
  {
    \"message\": \"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\"
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  """

  plugin_config do
    required(:source).array(:string).description("Field to remove. Accept an array to delete several fields at once")
  end

  def initialize()
    super("remove_fields")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    sources = params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")
    record_delete(sources)
  end
end