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

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [path](#path) | Path of fields to read. Wildcards are allowed to target multiple files | <code>string</code> |  | Yes |
| [format](#format) | Decoding format of files. 'auto' use extension files to determine the right format | <code>string</code> | auto | No |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### path

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Path of fields to read. Wildcards are allowed to target multiple files

- Value type is <code>string</code>

### format

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Decoding format of files. 'auto' use extension files to determine the right format

- Value type is <code>string</code>
- The default is `auto`

