# tcp <Badge type='tip' text='community' vertical='top' />

## Description

Tcp plugin allowed Dataqube parser to accept TCP payload


:: danger ::
Not working yet
::
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [tag](#tag) | Which tag to apply to your input data | <code>string</code> |  | Yes |
| [port](#port) | The port to listen to | <code>integer</code> | `null` | No |
| [bind](#bind) | The bind address to listen to | <code>string</code> | 0.0.0.0 | No |
| [format](#format) | Decoding format of data. 'auto' use extension files to determine the right format | <code>string</code> | auto | No |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### tag

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Which tag to apply to your input data

- Value type is <code>string</code>

### port

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
The port to listen to

- Value type is <code>integer</code>
- The default is `null`

### bind

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
The bind address to listen to

- Value type is <code>string</code>
- The default is `0.0.0.0`

### format

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Decoding format of data. 'auto' use extension files to determine the right format

- Value type is <code>string</code>
- The default is `auto`

