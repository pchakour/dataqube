# size <Badge text=beta type=warn/>


| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | null | Yes | null
| [when](#when) | null | Yes | null
| [message](#message) | null | Yes | null
| [severity](#severity) | null | No | info
| [source](#source) | null | Yes | null
| [min](#min) | null | No | 0
| [max](#max) | null | No | 0
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

### min
- Value type is integer
- The default is 0

### max
- Value type is integer
- The default is 0

### expected
- Value type is [
  "failure",
  "success"
]
- The default is success

