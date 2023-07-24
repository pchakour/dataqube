# ruby <Badge type='tip' text='community' vertical='top' />

Execute ruby code

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [once](#once) | Code executed once at the startup. Could be useful to initialize some variables. | No | null
| [each](#each) | Code executed for each event | No | 

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is ``

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is ``

## Plugin parameters
### once
<br/>
<Badge type=warning text=optional vertical=bottom />

Code executed once at the startup. Could be useful to initialize some variables.
- Value type is `string`
- The default is ``

### each
<br/>
<Badge type=warning text=optional vertical=bottom />

Code executed for each event
- Value type is `string`
- The default is ``

