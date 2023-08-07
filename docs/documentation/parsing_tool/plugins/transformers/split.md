# split <Badge type='tip' text='community' vertical='top' />

## Description

Split an event in several events based on the specified field


::: warning
Limitation only one by tag and at the end of the transform section
:::

<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{10-11}
- tag: EXAMPLE_SPLIT
  extract:
    - type: grok
      pattern: "Los Angeles temperatures: %{GREEDYDATA:temperatures}"
  transform:
    - type: list
      source: temperatures
      target: temperatures
      overwrite: true
    - type: split
      source: temperatures
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

```json
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":64, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":65, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":67, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":67, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":65, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":65, "_dataqube.tags":["EXAMPLE_SPLIT"]}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]", "temperatures":66, "_dataqube.tags":["EXAMPLE_SPLIT"]}
```

</CodeGroupItem>
</CodeGroup>


## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Field containing array to split in several events. You can specify an array | <code>any of ["array", "string"]</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### source

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Field containing array to split in several events. You can specify an array

- Value type is <code>any of ["array", "string"]</code>

