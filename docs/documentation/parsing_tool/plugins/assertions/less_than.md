# less_than <Badge type='tip' text='community' vertical='top' />

## Description

Check if a field value is less than a specified value


<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-8}
- tag: EXPECTED_TEMPERATURE
  extract:
    - type: grok
      pattern: "Los Angeles max temperature is %{NUMBER:temperature:int}"
  assert:
    - type: less_than
      source: temperature
      value: 70
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

```json
{
  "message": "Los Angeles max temperature is 71"
}
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{6-16}
{
  "temperature": 68,
  "expected": 50,
  "message": "Los Angeles max temperature is 71",
  "_dataqube.tags": ["EXPECTED_TEMPERATURE"],
  "_dataqube.quality": [
    {
      "tag": "EXPECTED_TEMPERATURE",
      "message": "Fields temperature must be less than 70",
      "severity": "info",
      "expected": "70",
      "value": "71",
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
| [source](#source) | Source field to check | <code>array&lt;string&gt;</code> |  | Yes |
| [value](#value) | Value to compare | <code>array&lt;integer&#124;string&gt;</code> |  | Yes |

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

- Value type is <code>array&lt;string&gt;</code>

### value

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Value to compare

- Value type is <code>array&lt;integer&#124;string&gt;</code>
- [Field interpretation](#) is supported for this parameter

