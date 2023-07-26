# join <Badge type='tip' text='community' vertical='top' />

## Description
Join events

## List of parameters
| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null |
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null |
| [by](#by) | Key shared between events to join. This field is a ruby instruction. | Yes | null |
| [from](#from) | Determine the beginning of a join section | Yes | null |
| [until](#until) | Determine the end of a join section | Yes | null |
| [using](#using) | What to do to join events | Yes | null |

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
### by
<br/>
<Badge type=tip text=required vertical=bottom />

Key shared between events to join. This field is a ruby instruction.
- Value type is `string`

### from
<br/>
<Badge type=tip text=required vertical=bottom />

Determine the beginning of a join section

Value type is an object composed by the following properties: 
#### rule_tag

<br/>
<Badge type=tip text=required vertical=bottom />

  Check if an event is tagged by the rule_tag

  - Value type is `null`

### until
<br/>
<Badge type=tip text=required vertical=bottom />

Determine the end of a join section

Value type is an object composed by the following properties: 
#### rule_tag

<br/>
<Badge type=tip text=required vertical=bottom />

  Check if an event is tagged by the rule_tag

  - Value type is `null`

### using
<br/>
<Badge type=tip text=required vertical=bottom />

What to do to join events

Value type is an object composed by the following properties: 
#### when

<br/>
<Badge type=tip text=required vertical=bottom />


Value type is an object composed by the following properties: 
##### code

<br/>
<Badge type=tip text=required vertical=bottom />

    Ruby code to execute when conditions are met

    - Value type is `null`
##### rule_tag

<br/>
<Badge type=tip text=required vertical=bottom />

    Check if an event is tagged by the rule_tag

    - Value type is `null`
- [Multi mode](#) is supported by this parameter

