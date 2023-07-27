# list <Badge type='tip' text='community' vertical='top' />

## Description
Parse a serialized list

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [source](#source) | Source field to parse | No | message |
| [target](#target) | Target field to store parsed data.<br/>By default, the parsed data will be merged with the target field.<br/>If no target is provided, the data will be merge with the event. | No | null |
| [overwrite](#overwrite) | Change the default behavior that merge parsed data with target. True will replace the target field value by the parsed data | No | false |

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

Source field to parse
- Value type is `string`
- The default is `message`

### target
<br/>
<Badge type=warning text=optional vertical=bottom />

Target field to store parsed data.
By default, the parsed data will be merged with the target field.
If no target is provided, the data will be merge with the event.
- Value type is `string`
- The default is `null`

### overwrite
<br/>
<Badge type=warning text=optional vertical=bottom />

Change the default behavior that merge parsed data with target. True will replace the target field value by the parsed data
- Value type is `boolean`
- The default is `false`

