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

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Source field to use for the extraction | <code>string</code> |  | Yes |

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
Source field to use for the extraction

- Value type is <code>string</code>

