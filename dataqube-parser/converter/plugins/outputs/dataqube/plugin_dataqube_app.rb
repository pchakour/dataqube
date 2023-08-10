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

  # plugin_config do
    # required(:project_id).filled(:string).description("The id of your project in Dataqube App")
    # optional(:project_version).filled(:string).default('last').description("Version of the analysis")
  # end

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