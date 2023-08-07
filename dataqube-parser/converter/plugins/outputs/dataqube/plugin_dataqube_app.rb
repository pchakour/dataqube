require_relative '../../../core/output'

class DataqubeApp < Dataqube::Output
  plugin_license "community"
  plugin_desc "Output data to dataqube app"
  plugin_details """

  <CodeGroup>
  <CodeGroupItem title='CONFIG'>
  
  ```yaml
  - type: dataqube
  ```
  
  </CodeGroupItem>
  </CodeGroup>

  """

  def initialize()
    super("dataqube_app")
  end

  def raw(parser, params)
    if parser === :fluentd
      ""
    else
      ""
    end
  end
end