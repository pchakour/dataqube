# list <Badge type='tip' text='community' vertical='top' />

## Description

Parse a serialized list


  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-9}
- tag: EXAMPLE_LIST
  extract:
    - type: grok
      pattern: 'Los Angeles temperatures: \[%{GREEDYDATA:temperatures}\]'
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
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{3}
  {
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]",
    "temperatures": [64, 65, 67, 67, 65, 65, 66],
    "_dataqube.tags": ["EXAMPLE_LIST"]
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Source field to parse | <code>string</code> |  | Yes |
| [target](#target) | Target field to store parsed data.<br/>  By default, the parsed data will be merged with the target fiel... | <code>string</code> | `null` | No |
| [overwrite](#overwrite) | Change the default behavior that merge parsed data with target. True will replace the target field v... | <code>boolean</code> | `null` | No |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### source

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Source field to parse

- Value type is <code>string</code>

### target

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Target field to store parsed data.
  By default, the parsed data will be merged with the target field.
  If no target is provided, the data will be merge with the event.

- Value type is <code>string</code>
- The default is `null`

### overwrite

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Change the default behavior that merge parsed data with target. True will replace the target field value by the parsed data

- Value type is <code>boolean</code>
- The default is `null`

