require_relative '../../../core/output'

class Stdout < Dataqube::Output
  plugin_license "community"
  plugin_desc "Output data to stdout"
  plugin_details """

  <CodeGroup>
  <CodeGroupItem title='CONFIG'>
  
  ```yaml
  - type: stdout
  ```
  
  </CodeGroupItem>
  </CodeGroup>

  """

  def initialize()
    super("stdout")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <match *>
        @type stdout
        output_type json
      </match>
    "
    else
      ""
    end
  end
end