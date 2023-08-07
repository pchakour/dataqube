# add_field <Badge type='tip' text='community' vertical='top' />

## Description

This plugin allow you to add a new field in your record


<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{3-5}
- tag: EXAMPLE_ADD_FIELD
  transform:
    - type: add_field
      name: new_field_message
      value: "Message => %{message}"
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

  ```json
  {
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{3}
  {
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]",
    "new_field_message": "Message => Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]"
    "_dataqube.tags": ["EXAMPLE_ADD_FIELD"],
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [name](#name) | New field name | <code>string</code> |  | Yes |
| [value](#value) | New value field | <code>string</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### name

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
New field name

- Value type is <code>string</code>

### value

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
New value field

- Value type is <code>string</code>
- [Field interpretation](#) is supported for this parameter

