# eq <Badge text=beta type=warn/>


| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | null | Yes | null
| [when](#when) | null | Yes | null
| [message](#message) | null | Yes | null
| [severity](#severity) | null | No | info
| [source](#source) | null | Yes | null
| [value](#value) | null | Yes | null
| [expected](#expected) | null | No | success

## Common parameters
### tag
- Value type is string
- The default is null

### when
- Value type is string
- The default is null

### message
- Value type is string
- The default is null

### severity
- Value type is [
  "fatal",
  "major",
  "minor",
  "info"
]
- The default is info

## Plugin parameters
### source
- Value type is string
- The default is null

### value
- Value type is any
- The default is null

### expected
- Value type is [
  "failure",
  "success"
]
- The default is success

