# elasticsearch <Badge type='tip' text='community' vertical='top' />

## Description

Output data to an Elasticsearch database



  <CodeGroup>
  <CodeGroupItem title='CONFIG'>
  
  ```yaml
  - type: elasticsearch
    scheme: https
    user: admin
    password: admin
    cacert: path/to/cacert.pem
  ```
  
  </CodeGroupItem>
  </CodeGroup>

  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [scheme](#scheme) | Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL | <code>string</code> | http | No |
| [host](#host) | The hostname of your Elasticsearch node | <code>string</code> | localhost | No |
| [port](#port) | The port number of your Elasticsearch node | <code>integer</code> | 9200 | No |
| [index](#index) | The index name to write events to | <code>string</code> | dataqube | No |
| [user](#user) | You can specify user for HTTP Basic authentication | <code>string</code> | `null` | No |
| [password](#password) | You can specify password for HTTP Basic authentication | <code>string</code> | `null` | No |
| [cacert](#cacert) | Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA | <code>string</code> | `null` | No |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### scheme

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL

- Value type is <code>string</code>
- The default is `http`

### host

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
The hostname of your Elasticsearch node

- Value type is <code>string</code>
- The default is `localhost`

### port

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
The port number of your Elasticsearch node

- Value type is <code>integer</code>
- The default is `9200`

### index

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
The index name to write events to

- Value type is <code>string</code>
- The default is `dataqube`

### user

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
You can specify user for HTTP Basic authentication

- Value type is <code>string</code>
- The default is `null`

### password

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
You can specify password for HTTP Basic authentication

- Value type is <code>string</code>
- The default is `null`

### cacert

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA

- Value type is <code>string</code>
- The default is `null`

