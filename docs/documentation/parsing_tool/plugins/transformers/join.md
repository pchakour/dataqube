# join <Badge type='tip' text='community' vertical='top' />

## Description

Join events

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [by](#by) | Key shared between events to join. This field is a ruby instruction. | <code>string</code> |  | Yes |
| [from](#from) | Determine the beginning of a join section | <code>object</code> |  | Yes |
| [until](#until) | Determine the end of a join section | <code>object</code> |  | Yes |
| [using](#using) | What to do to join events | <code>array&lt;object&gt;</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### by

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Key shared between events to join. This field is a ruby instruction.

- Value type is <code>string</code>

### from

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Determine the beginning of a join section

- Value type is <code>object</code>

This object contains the following properties:

#### from.rule_tag

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Tag of a rule

- Value type is <code>string</code>

### until

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Determine the end of a join section

- Value type is <code>object</code>

This object contains the following properties:

#### until.rule_tag

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Tag of a rule

- Value type is <code>string</code>

### using

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
What to do to join events

- Value type is <code>array&lt;object&gt;</code>

This array contains objects with the following properties:

#### using[].when

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
When apply the code

- Value type is <code>object</code>

This object contains **any of** the following properties:

#### using[].when.rule_tag

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Tag of a rule

- Value type is <code>string</code>

#### using[].when.predicate

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Predicate

- Value type is <code>string</code>

#### using[].code

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Code to execute

- Value type is <code>string</code>

