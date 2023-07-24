# size <Badge type='tip' text='community' vertical='top' />

Check if the size of an array is include between a min and a max. Min and max are included.

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [message](#message) | Message to store when assert event | No | null
| [severity](#severity) | Severity of the assertion | No | info
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success
| [source](#source) | Source field to check. The field must be an array. | Yes | null
| [min](#min) | Min value | No | 0
| [max](#max) | Max value | No | 0

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is `0`

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is `0`

### message
<br/>
<Badge type=warning text=optional vertical=bottom />

Message to store when assert event
- Value type is `string`
- The default is `0`

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
- The default is `0`

### expected
<br/>
<Badge type=warning text=optional vertical=bottom />

Indicate if you expect the check failed or succeed
- Value type is `[
  "failure",
  "success"
]`
- The default is `0`

## Plugin parameters
### source
<br/>
<Badge type=tip text=required vertical=bottom />

Source field to check. The field must be an array.
- Value type is `string`

### min
<br/>
<Badge type=warning text=optional vertical=bottom />

Min value
- Value type is `integer`
- The default is `0`

### max
<br/>
<Badge type=warning text=optional vertical=bottom />

Max value
- Value type is `integer`
- The default is `0`

