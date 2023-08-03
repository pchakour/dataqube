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

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [message](#message) | Message to store when assert event | <code>string</code> | `null` | No |
| [severity](#severity) | Severity of the assertion | <code>string</code> | info | No |
| [expected](#expected) | Indicate if you expect the check failed or succeed | <code>string</code> | success | No |
| [source](#source) | Source field to check | <code>string</code> |  | Yes |
| [value](#value) | Value to compare | <code>array&lt;string&#124;integer&gt;</code> |  | Yes |

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

- Value type is <code>string</code>

### value

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Value to compare

- Value type is <code>array&lt;string&#124;integer&gt;</code>
- [Field interpretation](#) is supported for this parameter

