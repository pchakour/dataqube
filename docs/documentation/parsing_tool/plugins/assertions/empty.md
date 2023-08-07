# empty <Badge type='tip' text='community' vertical='top' />

## Description

Check if a field value is empty


  Empty `string`, `array` and the value `nil` are consider empty by the plugin.

  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{11-13}
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

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [message](#message) | Message to store when assert event | <code>string</code> | `null` | No |
| [severity](#severity) | Severity of the assertion | <code>string</code> | info | No |
| [expected](#expected) | Indicate if you expect the check failed or succeed | <code>string</code> | success | No |
| [source](#source) | Source field to check | <code>any of ["array", "string"]</code> |  | Yes |

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
Source field to check

- Value type is <code>any of ["array", "string"]</code>

