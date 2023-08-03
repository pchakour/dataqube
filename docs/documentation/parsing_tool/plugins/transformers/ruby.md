# ruby <Badge type='tip' text='community' vertical='top' />

## Description

Execute ruby code


  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-12}
- tag: EXAMPLE_RUBY
  extract:
    - type: grok
      pattern: "Los Angeles temperatures: %{GREEDYDATA:temperatures}"
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
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{3}
  {
    "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]",
    "temperatures": [54, 55, 57, 57, 55, 55, 56],
    "_dataqube.tags": ["EXAMPLE_RUBY"]
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [once](#once) | Code executed once at the startup. Could be useful to initialize some variables. | <code>string</code> | `null` | No |
| [each](#each) | Code executed for each event | <code>string</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### once

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Code executed once at the startup. Could be useful to initialize some variables.

- Value type is <code>string</code>
- The default is `null`

### each

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Code executed for each event

- Value type is <code>string</code>

