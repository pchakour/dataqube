require_relative '../../../core/output'

class Elasticsearch < Dataqube::Output
  desc "Scheme of e"
  config_param :scheme, ['http', 'https'], default: 'http'
  config_param :host, :string, default: 'localhost'
  config_param :port, :integer, default: 9200
  config_param :index, :string, default: 'dataqube'
  config_param :user, :string, default: nil
  config_param :password, :string, default: nil
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
        logstash_format true
        logstash_prefix #{params[:index]}
        user #{params[:user]}
        password #{params[:password]}
        ca_file #{params[:cacert]}
        buffer_type memory
        flush_interval 5s
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