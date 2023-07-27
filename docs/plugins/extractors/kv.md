# kv <Badge type='tip' text='community' vertical='top' />

## Description
Extract data using key value pattern


<CodeGroup>
<CodeGroupItem title='CONFIG'>

```yaml{3-4}
- tag: EXTRACT_TEMPERATURES
  extract:
    - type: kv
      source: message
```

</CodeGroupItem>
<CodeGroupItem title='EVENT'>

```json
{
"message": "Temperatures: LosAngeles=65 NewYork=63 Paris=55"
}
```

</CodeGroupItem>
<CodeGroupItem title='OUTPUT'>

```json{3-5}
{
  "message": "Temperatures: LosAngeles=65 NewYork=63 Paris=55",
  "LosAngeles": "65",
  "NewYork": "63",
  "Paris": "55",
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
| [source](#source) | Source field to use for the extraction | Yes | null |

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
<Badge type=tip text=required vertical=bottom />

Source field to use for the extraction
- Value type is `string`

