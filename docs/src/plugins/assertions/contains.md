# contains <Badge text=beta type=warn/>

Check if an array contains a specific value

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | null | Yes | null
| [when](#when) | null | Yes | null
| [message](#message) | null | Yes | null
| [severity](#severity) | null | No | info
| [source](#source) | Source field to check. The field must be an array. | Yes | null
| [value](#value) | Value to find in the array | Yes | null
| [expected](#expected) | Indicate if you expect the check failed or succeed | No | success

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

Source field to check. The field must be an array.
### value
- Value type is any
- The default is null

Value to find in the array
### expected
- Value type is [
  "failure",
  "success"
]
- The default is success

Indicate if you expect the check failed or succeed
