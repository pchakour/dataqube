# remove_fields <Badge type='tip' text='community' vertical='top' />

## Description
Remove fields from an event

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [source](#source) | Field to remove. Accept an array to delete several fields at once | Yes | null |

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

Field to remove. Accept an array to delete several fields at once
- Value type is `string`
- [Multi mode](#) is supported by this parameter

