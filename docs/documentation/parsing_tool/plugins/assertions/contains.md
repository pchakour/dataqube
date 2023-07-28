# contains <Badge type='tip' text='community' vertical='top' />

## Description
Check if an array contains a specific value

  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{10-12}
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
    - type: contains
      source: temperatures
      value: 50
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

```json{5-15}
{
  "message": "Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]",
  "temperatures": [64, 65, 67, 67, 65, 65, 66],
  "_dataqube.tags": ["EXTRACT_TEMPERATURES"],
  "_dataqube.quality": [
    {
      "tag": "EXTRACT_TEMPERATURES",
      "message": "Field temperatures must contain 50",
      "severity": "info",
      "expected": "50",
      "value": "[64, 65, 67, 67, 65, 65, 66]",
      "status": "unresolved",
      "id": "641b49e6-449e-4fbc-bd98-25829d77c3fc"
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
| [value](#value) | Value to find in the array | Yes | null |

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

### value
<br/>
<Badge type=tip text=required vertical=bottom />

Value to find in the array
- Value type is `any`
- [Field interpretation](#) is supported for this parameter

