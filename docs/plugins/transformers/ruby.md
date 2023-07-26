# ruby <Badge type='tip' text='community' vertical='top' />

## Description
Execute ruby code

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [once](#once) | Code executed once at the startup. Could be useful to initialize some variables. | No | null |
| [each](#each) | Code executed for each event | No |  |

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
### once
<br/>
<Badge type=warning text=optional vertical=bottom />

Code executed once at the startup. Could be useful to initialize some variables.
- Value type is `string`
- The default is `null`

### each
<br/>
<Badge type=warning text=optional vertical=bottom />

Code executed for each event
- Value type is `string`
- The default is ``

