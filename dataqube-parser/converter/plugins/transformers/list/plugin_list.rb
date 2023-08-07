require_relative '../../../core/transformer'

class List < Dataqube::Transformer
  plugin_desc "Parse a serialized list"
  plugin_license "community"
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-9}
- tag: EXAMPLE_LIST
  extract:
    - type: grok
      pattern: 'Los Angeles temperatures: \\[%{GREEDYDATA:temperatures}\\]'
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
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
    \"_dataqube.tags\": [\"EXAMPLE_LIST\"]
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  """

  plugin_config do
    required(:source).filled(:string).default('message').description("Source field to parse")
    optional(:target).filled(:string).description("""Target field to store parsed data.
  By default, the parsed data will be merged with the target field.
  If no target is provided, the data will be merge with the event.""")
    optional(:overwrite).filled(:bool).default(false).description("Change the default behavior that merge parsed data with target. True will replace the target field value by the parsed data")
  end

  def initialize()
    super("list")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    source = params[:source]
    target = params[:target]
    overwrite = params[:overwrite]
    target_output = "record = merge_hash(record, list)"
    if target
      if overwrite
        target_output = "#{record(target)} = list"
      else
        target_output = "#{record(target)} = merge_hash(#{record(target)}, list)"
      end
    end

    %{
      list = parse_list(#{record(source)})
      #{target_output}
    }
  end
end