# tail <Badge type='tip' text='community' vertical='top' />

## Description
Tail files from a specific path

This plugin will add the file path to your event in a field named `filepath`.

<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml
- type: tail
  path: /my/path/to/files/test.log
  tag: LOG
```

  </CodeGroupItem>
  <CodeGroupItem title='DATA'>

```
Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]
New York temperatures: [68, 66, 70, 67, 65, 68, 70]
Paris temperatures: [59, 60, 62, 64, 58, 63, 64]
```

  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>

```json{5-15}
{"message":"Los Angeles temperatures: [64, 65, 67, 67, 65, 65, 66]","filepath":"/my/path/to/files/test.log"}
{"message":"New York temperatures: [68, 66, 70, 67, 65, 68, 70]","filepath":"/my/path/to/files/test.log"}
```

  </CodeGroupItem>
</CodeGroup>
  

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [path](#path) | Path of fields to read. Wildcards are allowed to target multiple files | Yes | null |
| [format](#format) | Decoding format of files. 'auto' use extension files to determine the right format | No | auto |

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

