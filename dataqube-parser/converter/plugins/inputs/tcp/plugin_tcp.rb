require_relative '../../../core/input'

class Tcp < Dataqube::Input
  plugin_license "community"
  plugin_desc "Tcp plugin allowed Dataqube parser to accept TCP payload"
  plugin_details """

  """

  plugin_config do
    optional(:port)
      .filled(:integer)
      .description("The port to listen to")

    optional(:bind)
      .filled(:string)
      .default('0.0.0.0')
      .description("The bind address to listen to")
  end

  def initialize()
    super("tcp")
  end

  def raw(parser, params)
    if parser === :fluentd
      conversion = "
      <source>
        @type tcp
        port #{params[:port]}
        bind #{params[:bind]}
      </source
    "

      return conversion
    else
      ""
    end
  end
end