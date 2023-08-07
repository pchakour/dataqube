# uuid <Badge type='tip' text='community' vertical='top' />

## Description

Generate a unique id in the specified target


  <CodeGroup>
  <CodeGroupItem title='CONFIG'>

```yaml{6-7}
- tag: EXAMPLE_UUID
  transform:
    - type: uuid
      target: my_super_id
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
    "my_super_id": "daa24ca4-826f-4a5e-9c19-3c02ea9794e5",
    "_dataqube.tags": ["EXAMPLE_UUID"],
  }
  ```
  
  </CodeGroupItem>
</CodeGroup>
  

## List of parameters

| Parameter | Description | Type | Default | Required |
|---|---|---|---|---|
| [when](#when) | Ruby predicate to indicate when execute this plugin | <code>string</code> | `null` | No |
| [target](#target) | Field in which stored the unique id | <code>string</code> |  | Yes |

### when

<br/>
<Badge type='warning' text='optional' vertical='bottom' />
<br/><br/>
Ruby predicate to indicate when execute this plugin

- Value type is <code>string</code>
- The default is `null`

### target

<br/>
<Badge type='tip' text='required' vertical='bottom' />
<br/><br/>
Field in which stored the unique id

- Value type is <code>string</code>

