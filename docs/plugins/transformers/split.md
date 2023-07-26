# split <Badge type='tip' text='community' vertical='top' />

## Description
<br/>  Split an event in several events based on the specified field<br/><br/>  ::: warning<br/>    Limitation only one by tag and at the end of the transform section<br/>  :::<br/>  

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [source](#source) | Field to split in several events. You can specify an array | Yes | null |

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

Field to split in several events. You can specify an array
- Value type is `string`
- [Multi mode](#) is supported by this parameter

