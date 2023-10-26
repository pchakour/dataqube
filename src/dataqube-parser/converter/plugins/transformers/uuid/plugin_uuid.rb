require_relative '../../../core/transformer'

class Uuid < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Generate a unique id in the specified target"
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-7}
- tag: EXAMPLE_UUID
  transform:
    - type: uuid
      target: my_super_id
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

  ```json
  {
    \"message\": \"2023-07-07T06:51:20.763Z Temperatures: LosAngeles=65 NewYork=63 Paris=55\"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{5-15}
  {
    \"message\": \"2023-07-07T06:51:20.763Z Temperatures: LosAngeles=65 NewYork=63 Paris=55\",
    \"my_super_id\": \"daa24ca4-826f-4a5e-9c19-3c02ea9794e5\",
    \"_dataqube.tags\": [\"EXAMPLE_UUID\"],
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  """

  plugin_config do
    required(:target).filled(:string).description("Field in which stored the unique id")
  end

  def initialize()
    super("uuid")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      #{record(params[:target])} = uuid()
    }
  end
end