# tail <Badge type='tip' text='community' vertical='top' />

Tail files from a specific path

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [path](#path) | Path of fields to read. Wildcards are allowed to target multiple files | Yes | null
| [format](#format) | Decoding format of files. 'auto' use extension files to determine the right format | No | auto

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is `auto`

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is `auto`

## Plugin parameters
### path
<br/>
<Badge type=tip text=required vertical=bottom />

Path of fields to read. Wildcards are allowed to target multiple files
- Value type is `string`

### format
<br/>
<Badge type=warning text=optional vertical=bottom />

Decoding format of files. 'auto' use extension files to determine the right format
- Value type is `[
  "auto",
  "raw",
  "json"
]`
- The default is `auto`

