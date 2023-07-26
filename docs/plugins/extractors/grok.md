# grok <Badge type='tip' text='community' vertical='top' />

## Description
Extract informations using grok patterns
This plugin assert an error if the extraction process failed depending on the 'expected' parameter

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [source](#source) | Source field on which apply the grok pattern | No | message |
| [target](#target) | EXPLAIN THIS PARAM | No | message |
| [pattern](#pattern) | Pattern grok to use. You can specify several patterns to check | Yes | null |
| [severity](#severity) | Severity error | No | info |
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success |

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

Source field on which apply the grok pattern
- Value type is `string`
- The default is `message`

### target
<br/>
<Badge type=warning text=optional vertical=bottom />

EXPLAIN THIS PARAM
- Value type is `string`
- The default is `message`

### pattern
<br/>
<Badge type=tip text=required vertical=bottom />

Pattern grok to use. You can specify several patterns to check
- Value type is `string`
- [Multi mode](#) is supported by this parameter

### severity
<br/>
<Badge type=warning text=optional vertical=bottom />

Severity error
- Value type is `[
  "info",
  "major",
  "minor",
  "fatal"
]`
- The default is `info`

### expected
<br/>
<Badge type=warning text=optional vertical=bottom />

Indicate if you expect the check failed or succeed
- Value type is `[
  "failure",
  "success"
]`
- The default is `success`

