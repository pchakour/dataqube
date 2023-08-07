# Configuration

Parsing tool use a configuration file in yaml to work.

## Minimal configuration

This file must describe at least an input to get data and output to define where to output data.
You can use inputs plugin and outputs plugin to configure the parser as you wish.

This is a simple example with an input from file and an output to stdout

```yaml
inputs:
  - type: tail
    path: 'path/to/file.log'
    tag: from_file
  
output:
  - type: stdout
```


## Structure file

The configuration file is separated in several categories: system, inputs, outputs and rules.

### System configuration

This part allow you to define system configuration. Today, only `autostop` parameter exists and allow
you to stop automatically the parser if it doesn't receive data after a timeout in seconds.

```yaml
system:
  autostop:
    enable: true
    timeout: 10
```

Timeout parameter is optional and 10 seconds is the default value.

### Inputs configuration

Inputs section allow you to define a list of inputs to get data. You can find the list of available plugins
[here](/documentation/parsing_tool/plugins/inputs/).

### Outputs configuration

Outputs section allow you to define a list of outputs to output data. You can find the list of available plugins
[here](/documentation/parsing_tool/plugins/outputs/).

### Rules configuration

Rules section define the list of rules to apply to your data. The rule structure is the following:

| Property | Type | Description | Required |
|---|---|---|---|
| tag | `string` | Define a rule tag. This tag will be add to the event if it pass the rule | Yes |
| when | `{ 'predicate' => string }` | Define predicate to indicate if the event meets the condition to enter in the rule section | No |
| extract | `array` | Define a list of extraction using [extractor plugins](/documentation/parsing_tool/plugins/extractors/) | No |
| transform | `array` | Define a list of transformation using [transformer plugins](/documentation/parsing_tool/plugins/transformers/) | No |
| assert | `array` | Define a list of assertion using [assertion plugins](/documentation/parsing_tool/plugins/assertions/) | No |


This is an exemple of a rules section configuration:

```yaml
rules:
  - tag: CONTAINS_IS8601_DATE
    extract:
      - type: grok
        pattern: "%{TIMESTAMP_ISO8601}"
    
  - tag: ONLY_INFO_LOG_LEVEL
    extract:
      - type: grok
        pattern: "%{LOGLEVEL:[log][level]}"
    transform:
      # Duplicate log level field just for fun
      - type: add_field
        name: super_log_level
        value: "%{[log][level]}" # Use the field interpretation
    assert:
      - type: eq
        source: "[log][level]"
        value: info
```
