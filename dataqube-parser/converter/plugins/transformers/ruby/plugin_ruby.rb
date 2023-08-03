require_relative '../../../core/transformer'

class Ruby < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Execute ruby code"
  plugin_details """
  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-12}
- tag: EXAMPLE_RUBY
  extract:
    - type: grok
      pattern: \"Los Angeles temperatures: %{GREEDYDATA:temperatures}\"
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
    - type: ruby
      each: |-
        record['temperatures'] = record['temperatures'].map { |temperature| temperature - 10 }
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
    \"temperatures\": [54, 55, 57, 57, 55, 55, 56],
    \"_dataqube.tags\": [\"EXAMPLE_RUBY\"]
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  """

  plugin_config do
    optional(:once).value(:string).description("Code executed once at the startup. Could be useful to initialize some variables.")
    required(:each).filled(:string).description("Code executed for each event")
  end

  def initialize()
    super("ruby")
  end

  def once(rule_tag, params)
    if (params[:once])
      params[:once]
    else
      ""
    end
  end

  def each(rule_tag, params)
    params[:each]
  end
end