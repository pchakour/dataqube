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
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [source](#source) | Source field on which apply the grok pattern | No | message |
| [pattern](#pattern) | Pattern grok to use. You can specify several patterns to check | Yes | null |
| [severity](#severity) | Severity error | No | info |
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success |
| [overwrite](#overwrite) | Change the default merge behavior with overwriting | No | false |

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

## Plugin parameters
### source
<br/>
<Badge type=warning text=optional vertical=bottom />

Source field on which apply the grok pattern
- Value type is `string`
- The default is `message`

### pattern
<br/>
<Badge type=tip text=required vertical=bottom />

Pattern grok to use. You can specify several patterns to check
- Value type is `string`
- [Multi mode](#) is supported by this parameter

### severity
<br/>
<Badge type=warning text=optional vertical=bottom />

Severity error
- Value type is `[
  "info",
  "major",
  "minor",
  "fatal"
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

### overwrite
<br/>
<Badge type=warning text=optional vertical=bottom />

Change the default merge behavior with overwriting
- Value type is `boolean`
- The default is `false`

