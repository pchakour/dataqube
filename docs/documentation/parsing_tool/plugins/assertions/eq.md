# eq <Badge type='tip' text='community' vertical='top' />

## Description
Check if a field value is equal to a specified value

<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-8}
- tag: EXPECTED_TEMPERATURE
  extract:
    - type: grok
      pattern: "Los Angeles max temperature is %{NUMBER:temperature:int} expected %{NUMBER:expected:int}"
  assert:
    - type: eq
      source: temperature
      value: "%{expected:int}" # Use field interpretation here
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  "message": "Los Angeles max temperature is 68 expected 50"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{6-16}
{
  "temperature": 68,
  "expected": 50,
  "message": "Los Angeles max temperature is 68 expected 50",
  "_dataqube.tags": ["EXPECTED_TEMPERATURE"],
  "_dataqube.quality": [
    {
      "tag": "EXPECTED_TEMPERATURE",
      "message": "Fields temperature not matching",
      "severity": "info",
      "expected": "50",
      "value": "68",
      "status": "unresolved",
      "id": "1dd3d1fa-46eb-4ef0-b02f-1a30f850b7ec"
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
| [value](#value) | Value to compare | Yes | null |

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

### value
<br/>
<Badge type=tip text=required vertical=bottom />

Value to compare
- Value type is `any`
- [Field interpretation](#) is supported for this parameter

