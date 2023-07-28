# empty <Badge type='tip' text='community' vertical='top' />

## Description
Check if a field value is empty

  Empty `string`, `array` and the value `nil` are consider empty by the plugin.

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
    - type: empty
      source: temperatures
      expected: failure # We want the temperatures field not empty
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  "message": "Los Angeles temperatures: []"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{5-15}
{
  "temperatures": [],
  "message": "Los Angeles temperatures: []",
  "_dataqube.tags": ["EXTRACT_TEMPERATURES"],
  "_dataqube.quality": [
    {
      "tag": "EXTRACT_TEMPERATURES",
      "message": "Fields temperatures are empty",
      "severity": "info",
      "expected": "!["", nil, []]",
      "value": "[]",
      "status": "unresolved",
      "id": "803471cc-9b1b-4e15-96c8-1979ec4260fe"
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
| [source](#source) | Source field to check | Yes | null |

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

Source field to check
- Value type is `string`
- [Multi mode](#) is supported by this parameter

