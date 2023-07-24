# empty <Badge type='tip' text='community' vertical='top' />

Check if a field value is empty

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [message](#message) | Message to store when assert event | No | null
| [severity](#severity) | Severity of the assertion | No | info
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success
| [source](#source) | Source field to check | Yes | null

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is `null`

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
- The default is `null`

### expected
<br/>
<Badge type=warning text=optional vertical=bottom />

Indicate if you expect the check failed or succeed
- Value type is `[
  "failure",
  "success"
]`
- The default is `null`

## Plugin parameters
### source
<br/>
<Badge type=tip text=required vertical=bottom />

Source field to check
- Value type is `string` or an array of this type

