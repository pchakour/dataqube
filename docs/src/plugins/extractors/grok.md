# grok <Badge text=beta type=warn/>


| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | null | Yes | null
| [when](#when) | null | Yes | null
| [source](#source) | null | No | message
| [target](#target) | null | No | message
| [expected](#expected) | null | No | success
| [pattern](#pattern) | null | Yes | null
| [severity](#severity) | null | No | info

## Common parameters
### tag
- Value type is string
- The default is null

### when
- Value type is string
- The default is null

## Plugin parameters
### source
- Value type is string
- The default is message

### target
- Value type is string
- The default is message

### expected
- Value type is string
- The default is success

### pattern
- Value type is string
- The default is null

### severity
- Value type is [
  "info",
  "major",
  "minor",
  "fatal"
]
- The default is info

