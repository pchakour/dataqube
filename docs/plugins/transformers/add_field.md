# add_field <Badge type='tip' text='community' vertical='top' />


  This plugin allow you to add a new field in your record
  
  
<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{3-5}
- tag: EXAMPLE_ADD_FIELD
  transform:
    - type: add_field
      name: new_field_message
      value: "Message: %{message}"
```

  </CodeGroupItem>
</CodeGroup>
  

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [name](#name) | New field name | Yes | null
| [value](#value) | New value field | Yes | null

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is `null`

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is `null`

## Plugin parameters
### name
<br/>
<Badge type=tip text=required vertical=bottom />

New field name
- Value type is `string`

### value
<br/>
<Badge type=tip text=required vertical=bottom />

New value field
- Value type is `string`
- [Field interpretation](#) is accepted for this parameter

