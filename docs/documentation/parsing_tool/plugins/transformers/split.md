# split <Badge type='tip' text='community' vertical='top' />

## Description

Split an event in several events based on the specified field


::: warning
Limitation only one by tag and at the end of the transform section
:::


## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Field to split in several events. You can specify an array | <code>array&lt;string&gt;</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### source

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Field to split in several events. You can specify an array

- Value type is <code>array&lt;string&gt;</code>

