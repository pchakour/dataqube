# Transformers

Transform your data using one of the following plugins:

| Plugin | Description |
|---|---|
| [add_field](./add_field.md) | "\n  This plugin allow you to add a new field in your record\n  \n  \n<CodeGroup>\n  <CodeGroupItem title='CONFIG'>\n\n```yaml{3-5}\n- tag: EXAMPLE_ADD_FIELD\n  transform:\n    - type: add_field\n      name: new_field_message\n      value: \"Message: %{message}\"\n```\n\n  </CodeGroupItem>\n</CodeGroup>\n  " |
| [date](./date.md) | "Convert a string as a Date object" |
| [join](./join.md) | "Join events" |
| [list](./list.md) | "Parse a serialized list" |
| [remove_fields](./remove_fields.md) | "Remove fields from an event" |
| [ruby](./ruby.md) | "Execute ruby code" |
| [split](./split.md) | "\n  Split an event in several events based on the specified field\n\n  ::: warning\n    Limitation only one by tag and at the end of the transform section\n  :::\n  " |
| [uuid](./uuid.md) | "Generate a unique id in the specified target" |
