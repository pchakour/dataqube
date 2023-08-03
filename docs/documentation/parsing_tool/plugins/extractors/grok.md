# grok <Badge type='tip' text='community' vertical='top' />

## Description

Extract informations using grok patterns


::: warning
This plugin assert an error if the extraction process failed depending on the match result and the [expected](#expected) parameter.
:::

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{3-4}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: grok
      pattern: "Los Angeles temperatures: %{GREEDYDATA:temperatures}"
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
"temperatures": [64, 65, 67, 67, 65, 65, 66],
"_dataqube.tags": ["EXTRACT_TEMPERATURES"]
}
```

</CodeGroupItem>
</CodeGroup>


## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Source field on which apply the grok pattern | <code>string</code> | message | No |
| [pattern](#pattern) | <br/>Pattern grok to use. You can specify several patterns to check.<br/><br/>The pattern can use typing for a f... | <code>array&lt;string&gt;</code> |  | Yes |
| [severity](#severity) | Severity error | <code>string</code> | info | No |
| [expected](#expected) | Indicate if you expect the check failed or succeed | <code>string</code> | success | No |
| [overwrite](#overwrite) | Change the default merge behavior with overwriting | <code>boolean</code> | `null` | No |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### source

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Source field on which apply the grok pattern

- Value type is <code>string</code>
- The default is `message`

### pattern

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>

Pattern grok to use. You can specify several patterns to check.

The pattern can use typing for a field to convert the value to a string, an integer or a float.

Example to convert as an integer:

`%{NUMBER:name:int}`

or

`%{NUMBER:name:integer}`

The field support structure naming to create structured fields in your event.

`%{LOGLEVEL:[log][level]}`

will create the following event

`{ log: { level: 'info' }}`

The field name support also the use of `@metadata` structure to store temporary data.
`@metadata` are kept if the event has an assertion.

`%{NUMBER:[@metadata][name]}`
        

- Value type is <code>array&lt;string&gt;</code>

### severity

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Severity error

- Value type is <code>string</code>
- The default is `info`

### expected

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Indicate if you expect the check failed or succeed

- Value type is <code>string</code>
- The default is `success`

### overwrite

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Change the default merge behavior with overwriting

- Value type is <code>boolean</code>
- The default is `null`

