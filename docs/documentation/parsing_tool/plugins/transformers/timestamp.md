# timestamp <Badge type='tip' text='community' vertical='top' />

## Description

Convert a string as a Date object


::: warning
This plugin assert an error if the date parsing failed
:::

<CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-7}
- tag: EXAMPLE_PARSE_DATE
  extract:
    - type: grok
      pattern: ^%{TIMESTAMP_ISO8601:date} %{GREEDYDATA:log}$ 
  transform:
    - type: timestamp
      source: date
```

  </CodeGroupItem>
  <CodeGroupItem title='EVENT'>

  ```json
  {
    "message": "2023-07-07T06:51:20.763Z Temperatures: LosAngeles=65 NewYork=63 Paris=55"
  }
  ```
  
  </CodeGroupItem>
  <CodeGroupItem title='OUTPUT'>
  
  ```json{5-15}
  {
    "message": "2023-07-07T06:51:20.763Z Temperatures: LosAngeles=65 NewYork=63 Paris=55",
    "date": "2023-07-07T06:51:20.763Z",
    "log": "Temperatures: LosAngeles=65 NewYork=63 Paris=55",
    "_dataqube.tags": ["EXAMPLE_PARSE_DATE"],
    "timestamp": "2023-07-07T06:51:20Z"
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [source](#source) | Source to get date string | <code>string</code> |  | Yes |
| [target](#target) | Target to write the date object. By default, the date object will be use as default event date by st... | <code>string</code> | timestamp | No |
| [format](#format) | <br/>  Date format to use. By default, the plugin will use iso8601 format.<br/>  You can also specify an ano... | <code>string</code> | `null` | No |
| [severity](#severity) | Severity if the plugin assert an error | <code>string</code> | info | No |

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
Source to get date string

- Value type is <code>string</code>

### target

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Target to write the date object. By default, the date object will be use as default event date by storing it in the timestamp field

- Value type is <code>string</code>
- The default is `timestamp`

### format

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>

  Date format to use. By default, the plugin will use iso8601 format.
  You can also specify an another format using the following list of formatting options:
  
  | option | description |
  |---|---|
  | %a | The abbreviated weekday name (“Sun”) |
  | %A | The full weekday name (“Sunday”) |
  | %b | The abbreviated month name (“Jan”) |
  | %B | The full month name (“January”) |
  | %c | The preferred local date and time representation |
  | %C | Century (20 in 2009) |
  | %d | Day of the month (01..31) |
  | %D | Date (%m/%d/%y) |
  | %e | Day of the month, blank-padded ( 1..31) |
  | %F | Equivalent to %Y-%m-%d (the ISO 8601 date format) |
  | %h | Equivalent to %b |
  | %H | Hour of the day, 24-hour clock (00..23) |
  | %I | Hour of the day, 12-hour clock (01..12) |
  | %j | Day of the year (001..366) |
  | %k | hour, 24-hour clock, blank-padded ( 0..23) |
  | %l | hour, 12-hour clock, blank-padded ( 0..12) |
  | %L | Millisecond of the second (000..999) |
  | %m | Month of the year (01..12) |
  | %M | Minute of the hour (00..59) |
  | %n | Newline (n) |
  | %N | Fractional seconds digits, default is 9 digits (nanosecond) |
  | %3N | millisecond (3 digits) |
  | %6N | microsecond (6 digits) |
  | %9N | nanosecond (9 digits) |
  | %p | Meridian indicator (“AM” or “PM”) |
  | %P | Meridian indicator (“am” or “pm”) |
  | %r | time, 12-hour (same as %I:%M:%S %p) |
  | %R | time, 24-hour (%H:%M) |
  | %s | Number of seconds since 1970-01-01 00:00:00 UTC. |
  | %S | Second of the minute (00..60) |
  | %t | Tab character (t) |
  | %T | time, 24-hour (%H:%M:%S) |
  | %u | Day of the week as a decimal, Monday being 1. (1..7) |
  | %U | Week number of the current year, starting with the first Sunday as the first day of the first week (00..53) |
  | %v | VMS date (%e-%b-%Y) |
  | %V | Week number of year according to ISO 8601 (01..53) |
  | %W | Week number of the current year, starting with the first Monday as the first day of the first week (00..53) |
  | %w | Day of the week (Sunday is 0, 0..6) |
  | %x | Preferred representation for the date alone, no time |
  | %X | Preferred representation for the time alone, no date |
  | %y | Year without a century (00..99) |
  | %Y | Year which may include century, if provided |
  | %z | Time zone as hour offset from UTC (e.g. +0900) |
  | %Z | Time zone name |
  

- Value type is <code>string</code>
- The default is `null`

### severity

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Severity if the plugin assert an error

- Value type is <code>string</code>
- The default is `info`

