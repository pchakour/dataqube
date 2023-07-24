require_relative '../../../core/output'

class Elasticsearch < Dataqube::Output
  plugin_desc "Output data to an Elasticsearch database"
  plugin_license "community"

  desc "Connection protocol to use, specify https if your Elasticsearch endpoint supports SSL"
  config_param :scheme, ['http', 'https'], default: 'http'
  desc "The hostname of your Elasticsearch node"
  config_param :host, :string, default: 'localhost'
  desc "The port number of your Elasticsearch node"
  config_param :port, :integer, default: 9200
  desc "The index name to write events to"
  config_param :index, :string, default: 'dataqube'
  desc "You can specify user for HTTP Basic authentication"
  config_param :user, :string, default: nil
  desc "You can specify password for HTTP Basic authentication"
  config_param :password, :string, default: nil
  desc "Need to verify Elasticsearch's certificate? You can use the following parameter to specify a CA"
  config_param :cacert, :string, default: nil

  def initialize()
    super("elasticsearch")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <match *>
        @type elasticsearch
        scheme #{params[:scheme]}
        host #{params[:host]}
        port #{params[:port]}
        index_name #{params[:index]}
        user #{params[:user]}
        password #{params[:password]}
        ca_file #{params[:cacert]}
        buffer_type memory
        flush_interval 5s
        @log_level debug
        retry_limit 5
        retry_wait 1.0
        num_threads 1
      </match>
    "
    else
      ""
    end
  end
end