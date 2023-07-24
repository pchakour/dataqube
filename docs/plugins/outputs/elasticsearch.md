# elasticsearch <Badge type='tip' text='community' vertical='top' />

Output data to an Elasticsearch database

| Parameter | Description | Required | Default |
|---|---|---|---|
| [tag](#tag) | List of tag to add if the plugin is well executed | No | null
| [when](#when) | Ruby predicate to indicate when execute this plugin | No | null
| [scheme](#scheme) | Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL | No | http
| [host](#host) | The hostname of your Elasticsearch node | No | localhost
| [port](#port) | The port number of your Elasticsearch node | No | 9200
| [index](#index) | The index name to write events to | No | dataqube
| [user](#user) | You can specify user for HTTP Basic authentication | No | null
| [password](#password) | You can specify password for HTTP Basic authentication | No | null
| [cacert](#cacert) | Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA | No | null

## Common parameters
### tag
<br/>
<Badge type=warning text=optional vertical=bottom />

List of tag to add if the plugin is well executed
- Value type is `string` or an array of this type
- The default is `null`

### when
<br/>
<Badge type=warning text=optional vertical=bottom />

Ruby predicate to indicate when execute this plugin
- Value type is `string`
- The default is `null`

## Plugin parameters
### scheme
<br/>
<Badge type=warning text=optional vertical=bottom />

Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL
- Value type is `[
  "http",
  "https"
]`
- The default is `null`

### host
<br/>
<Badge type=warning text=optional vertical=bottom />

The hostname of your Elasticsearch node
- Value type is `string`
- The default is `null`

### port
<br/>
<Badge type=warning text=optional vertical=bottom />

The port number of your Elasticsearch node
- Value type is `integer`
- The default is `null`

### index
<br/>
<Badge type=warning text=optional vertical=bottom />

The index name to write events to
- Value type is `string`
- The default is `null`

### user
<br/>
<Badge type=warning text=optional vertical=bottom />

You can specify user for HTTP Basic authentication
- Value type is `string`
- The default is `null`

### password
<br/>
<Badge type=warning text=optional vertical=bottom />

You can specify password for HTTP Basic authentication
- Value type is `string`
- The default is `null`

### cacert
<br/>
<Badge type=warning text=optional vertical=bottom />

Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA
- Value type is `string`
- The default is `null`

