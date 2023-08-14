require_relative '../../../core/output'

class Elasticsearch < Dataqube::Output
  plugin_license "community"
  plugin_desc "Output data to an Elasticsearch database"
  plugin_details """

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

  """

  plugin_config do
    optional(:scheme).filled(:string, included_in?: ['http', 'https']).default('http').description("Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL")
    optional(:host).filled(:string).default('localhost').description("The hostname of your Elasticsearch node")
    optional(:port).filled(:integer).default(9200).description("The port number of your Elasticsearch node")
    optional(:index).filled(:string).default('dataqube').description("The index name to write events to")
    optional(:user).value(:string).description("You can specify user for HTTP Basic authentication")
    optional(:password).value(:string).description("You can specify password for HTTP Basic authentication")
    optional(:cacert).value(:string).description("Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA")
  end

  def initialize()
    super("elasticsearch")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <match *>
        @type elasticsearch
        @log_level debug
        scheme #{params[:scheme]}
        host #{params[:host]}
        port #{params[:port]}
        index_name #{params[:index]}
        user #{params[:user]}
        password #{params[:password]}
        ca_file #{params[:cacert]}
        buffer_type memory
        flush_interval 5s
        num_threads 1
        type_name _doc
      </match>
    "
    else
      ""
    end
  end
end