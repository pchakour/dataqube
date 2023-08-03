require_relative '../../../core/transformer'

class AddField < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "This plugin allow you to add a new field in your record"
  plugin_details """
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{3-5}
- tag: EXAMPLE_ADD_FIELD
  transform:
    - type: add_field
      name: new_field_message
      value: \"Message => %{message}\"
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
    \"new_field_message\": \"Message => Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\"
    \"_dataqube.tags\": [\"EXAMPLE_ADD_FIELD\"],
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  """

  plugin_config do
    required(:name).filled(:string).description("New field name")
    required(:value).filled(:string).isInterpreted.description("New value field")
  end

  def initialize()
    super("add_field")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      #{record(params[:name])} = #{value(params[:value])}
    }
  end
end