require_relative '../../../core/transformer'

class AddField < Dataqube::Transformer
  plugin_desc """
  This plugin allow you to add a new field in your record
  
  
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{3-5}
- tag: EXAMPLE_ADD_FIELD
  transform:
    - type: add_field
      name: new_field_message
      value: \"Message: %{message}\"
```

  </CodeGroupItem>
</CodeGroup>
  """
  plugin_license "community"

  desc "New field name"
  config_param :name, :string
  desc "New value field"
  config_param :value, :string, { field_interpretation: true }

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