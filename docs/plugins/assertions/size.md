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
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [message](#message) | Message to store when assert event | No | null |
| [severity](#severity) | Severity of the assertion | No | info |
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success |
| [source](#source) | Source field to check. The field must be an array. | Yes | null |
| [min](#min) | Min value | No | 0 |
| [max](#max) | Max value | No | 0 |

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string`
- The default is `null`
- [Multi mode](#) is supported by this parameter

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is `null`

### message
<br/>
<Badge type=warning text=optional vertical=bottom />

Message to store when assert event
- Value type is `string`
- The default is `null`

### severity
<br/>
<Badge type=warning text=optional vertical=bottom />

Severity of the assertion
- Value type is `[
  "fatal",
  "major",
  "minor",
  "info"
]`
- The default is `info`

### expected
<br/>
<Badge type=warning text=optional vertical=bottom />

Indicate if you expect the check failed or succeed
- Value type is `[
  "failure",
  "success"
]`
- The default is `success`

## Plugin parameters
### source
<br/>
<Badge type=tip text=required vertical=bottom />

Source field to check. The field must be an array.
- Value type is `string`

### min
<br/>
<Badge type=warning text=optional vertical=bottom />

Min value
- Value type is `integer`
- The default is `0`

### max
<br/>
<Badge type=warning text=optional vertical=bottom />

Max value
- Value type is `integer`
- The default is `0`

