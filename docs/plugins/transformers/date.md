# date <Badge type='tip' text='community' vertical='top' />

Convert a string as a Date object

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [source](#source) | Source to get date string | Yes | null
| [target](#target) | Target to write the date object. By default, the source will be overwrite with the date object | No | null
| [format](#format) | Date format | No | null

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

## Plugin parameters
### source
<br/>
<Badge type=tip text=required vertical=bottom />

Source to get date string
- Value type is `string`

### target
<br/>
<Badge type=warning text=optional vertical=bottom />

Target to write the date object. By default, the source will be overwrite with the date object
- Value type is `string`
- The default is `null`

### format
<br/>
<Badge type=warning text=optional vertical=bottom />

Date format
- Value type is `string`
- The default is `null`

