# size <Badge type='tip' text='community' vertical='top' />

## Description

Check if the size of an array is include between a min and a max. Min and max are included.


  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-13}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: "Los Angeles temperatures: %{GREEDYDATA:temperatures}"
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
  assert:
    - type: size
      source: temperatures
      min: 1
      max: 5
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 68]"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{5-15}
{
  "temperatures": [64, 65, 67, 67, 65, 68],
  "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 68]",
  "_dataqube.tags": ["EXTRACT_TEMPERATURES"],
  "_dataqube.quality": [
    {
      "tag": "EXTRACT_TEMPERATURES",
      "message": "Fields temperatures size must be between or equal to 1 and 5",
      "severity": "info",
      "expected": "[1, 5]",
      "value": "6",
      "status": "unresolved",
      "id": "9587b5e6-4cb7-4f09-8b70-11577673dee1"
    }
  ]
}
```

  </CodeGroupItem>
</CodeGroup>


## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [message](#message) | Message to store when assert event | <code>string</code> | `null` | No |
| [severity](#severity) | Severity of the assertion | <code>string</code> | info | No |
| [expected](#expected) | Indicate if you expect the check failed or succeed | <code>string</code> | success | No |
| [source](#source) | Source field to check. The field must be an array. | <code>string</code> |  | Yes |
| [min](#min) | Min value | <code>integer</code> |  | Yes |
| [max](#max) | Max value | <code>integer</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### message

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Message to store when assert event

- Value type is <code>string</code>
- The default is `null`

### severity

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Severity of the assertion

- Value type is <code>string</code>
- The default is `info`

### expected

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Indicate if you expect the check failed or succeed

- Value type is <code>string</code>
- The default is `success`

### source

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Source field to check. The field must be an array.

- Value type is <code>string</code>

### min

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Min value

- Value type is <code>integer</code>

### max

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Max value

- Value type is <code>integer</code>

