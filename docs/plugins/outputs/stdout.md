# stdout <Badge type='tip' text='community' vertical='top' />

## Description
Output data to stdout


  <CodeGroup>
  <CodeGroupItem title='CONFIG'>
  
  ```yaml
  - type: stdout
  ```
  
  </CodeGroupItem>
  </CodeGroup>

  

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |

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
