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

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [message](#message) | Message to store when assert event | <code>string</code> | `null` | No |
| [severity](#severity) | Severity of the assertion | <code>string</code> | info | No |
| [expected](#expected) | Indicate if you expect the check failed or succeed | <code>string</code> | success | No |
| [source](#source) | Source field to check. The field must be an array. | <code>string</code> |  | Yes |
| [value](#value) | Value to find in the array | <code>any of ["integer", "string"]</code> |  | Yes |

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

### value

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Value to find in the array

- Value type is <code>any of ["integer", "string"]</code>
- [Field interpretation](#) is supported for this parameter

