require_relative '../../../core/output'

class Http < Dataqube::Output
  plugin_license "community"
  plugin_desc "Output data to an http endpoint"
  plugin_details """

  <CodeGroup>
  <CodeGroupItem title='CONFIG'>
  
  ```yaml
  - type: http
    endpoint: http://localhost:8080/api/endpoint
    format: json
    headers:
      - Authorization: 'Bearer TOKEN'
  ```
  
  </CodeGroupItem>
  </CodeGroup>

  """

  plugin_config do
    required(:endpoint).filled(:string).description("The endpoint for HTTP request. If you want to use HTTPS, use https prefix")
    optional(:format).filled(:string, included_in?: ['json', 'csv', 'msgpack']).default('json').description("The format of the payload")
    optional(:headers).filled(:hash).description("Additional headers for HTTP request")
  end

  def initialize()
    super("http")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <match *>
        @type http
        endpoint #{params[:endpoint]}
        <format>
          @type #{params[:format]}
        </format>
        json_array true
        headers #{params[:headers] ? params[:headers].to_json : nil}
        <buffer>
          flush_interval 2s
        </buffer>
      </match>
    "
    else
      ""
    end
  end
end