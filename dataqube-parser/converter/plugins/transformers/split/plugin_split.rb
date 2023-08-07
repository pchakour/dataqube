require_relative '../../../core/transformer'

class Split < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Split an event in several events based on the specified field"
  plugin_details """
::: warning
Limitation only one by tag and at the end of the transform section
:::

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{10-11}
- tag: EXAMPLE_SPLIT
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
    - type: split
      source: temperatures
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

```json
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":64, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":65, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":67, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":67, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":65, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":65, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
{\"message\":\"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]\", \"temperatures\":66, \"_dataqube.tags\":[\"EXAMPLE_SPLIT\"]}
```

</CodeGroupItem>
</CodeGroup>
"""

  plugin_config do
    required(:source){ (array? & str?) | str? }
      .description("Field containing array to split in several events. You can specify an array")
  end

  def initialize()
    super("split")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      record = split(record, sources)
    }
  end
end