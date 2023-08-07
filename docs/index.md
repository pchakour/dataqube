---
home: true
heroImage: /images/hero_logo_4.svg
heroText: DATAQUBE
tagline: The data quality tool
actions:
  - text: Get Started
    link: /guide/getting-started.html
    type: primary
  - text: Introduction
    link: /guide/
    type: secondary
features:
- title: Parsing tool
  details: You can extract, transform and assert your data with our parsing tool under Apache 2 license easily extendable
- title: Dataqube app
  details: Use our free Dataqube app to create projects, quality gate and rules. Explore the analysis result to fix error until to meet quality requirements
- title: Fluentd plugin
  details: Your already set up a fluentd parser for your data ? You can use our fluentd plugin to write ruby assertions.
footer: FOOTER
---

## Use our parsing tool

You can use our parsing tool independently of our Dataqube App. Easy to configure to validate your data.

<CodeGroup>
  <CodeGroupItem title='config'>

```yaml{1,8,14,18}
# Define system configuration
system:
  # Stop parser if it doesn't receive events for 2 seconds
  autostop:
    enabled: true
    timeout: 2

# Define where to get data
inputs:
  - type: tail
    path: path/to/my/log/file.log
    tag: from_log

# Define where to output data
outputs:
  - type: stdout

# Define your rules
rules:
  - tag: MAX_TEMPERATURE
    extract:
      - type: grok
        pattern: "%{TIMESTAMP_ISO:timestamp} Los Angeles temperature: %{NUMBER:temperature:int}"
    assert:
      - type: less_than
        source: temperature 
        value: 70
```

  </CodeGroupItem>
  <CodeGroupItem title='file.log'>

```log
2023-07-07T06:51:20.763Z Los Angeles temperature: 71

```
  </CodeGroupItem>
  <CodeGroupItem title='output'>
  
  ```json
 {
  "message": "2023-07-07T06:51:20.763Z Los Angeles temperature: 71",
  "filepath": "path/to/my/log/file.log",
  "timestamp": "2023-07-07T06:51:20.763Z",
  "temperature": 71,
  "_dataqube.tags": ["MAX_TEMPERATURE"],
  "_dataqube.quality": [
    {
      "tag": "MAX_TEMPERATURE",
      "message": "Fields temperature must be lower than 70",
      "severity": "info",
      "expected": "70",
      "value": "71",
      "status": "unresolved",
      "id": "4a237c66-85e2-4c93-893f-5ff8c129bb2b"
    }
  ]
}
  ```
  
  </CodeGroupItem>
</CodeGroup>

## Use our Dataqube App

SOON