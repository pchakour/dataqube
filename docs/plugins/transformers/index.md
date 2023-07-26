# Transformers

Transform your data using one of the following plugins:

| Plugin | Description |
|---|---|
| [add_field](./add_field.md) | <br/>  This plugin allow you to add a new field in your record<br/>  <br/>  <br/><CodeGroup><br/>  <CodeGroupItem title='CONFIG'><br/><br/>```yaml{3-5}<br/>- tag: EXAMPLE_ADD_FIELD<br/>  transform:<br/>    - type: add_field<br/>      name: new_field_message<br/>      value: "Message: %{message}"<br/>```<br/><br/>  </CodeGroupItem><br/></CodeGroup><br/>   |
| [date](./date.md) | Convert a string as a Date object |
| [join](./join.md) | Join events |
| [list](./list.md) | Parse a serialized list |
| [remove_fields](./remove_fields.md) | Remove fields from an event |
| [ruby](./ruby.md) | Execute ruby code |
| [split](./split.md) | <br/>  Split an event in several events based on the specified field<br/><br/>  ::: warning<br/>    Limitation only one by tag and at the end of the transform section<br/>  :::<br/>   |
| [uuid](./uuid.md) | Generate a unique id in the specified target |
