# uuid <Badge type='tip' text='community' vertical='top' />

Generate a unique id in the specified target

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [target](#target) | Field in which stored the unique id | Yes | null

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
### target
<br/>
<Badge type=tip text=required vertical=bottom />

Field in which stored the unique id
- Value type is `string`

