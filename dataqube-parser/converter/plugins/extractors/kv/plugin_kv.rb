require_relative '../../../core/extractor'

class Kv < Dataqube::Extractor
  plugin_license "community"
  plugin_desc "Extract data using key value pattern"
  plugin_details """

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{3-4}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: kv
      source: message
```

</CodeGroupItem>
<CodeGroupItem title='EVENT'>

```json
{
\"message\": \"Temperatures: LosAngeles=65 NewYork=63 Paris=55\"
}
```

</CodeGroupItem>
<CodeGroupItem title='OUTPUT'>

```json{3-5}
{
  \"message\": \"Temperatures: LosAngeles=65 NewYork=63 Paris=55\",
  \"LosAngeles\": \"65\",
  \"NewYork\": \"63\",
  \"Paris\": \"55\",
  \"_dataqube.tags\": [\"EXTRACT_TEMPERATURES\"]
}
```

</CodeGroupItem>
</CodeGroup>

  """

  desc "Source field to use for the extraction"
  config_param :source, :string

  def initialize()
    super("kv")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      kv_result = {}
      kv_result = parse_kv(#{record(params[:source])})
      record = merge_hash(record, kv_result)
    }
  end
end