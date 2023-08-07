require_relative '../../../core/input'

class Tcp < Dataqube::Input
  plugin_license "community"
  plugin_desc "Tcp plugin allowed Dataqube parser to accept TCP payload"
  plugin_details """
:: danger ::
Not working yet
::
  """

  plugin_config do
    optional(:port)
      .filled(:integer)
      .description("The port to listen to")

    optional(:bind)
      .filled(:string)
      .default('0.0.0.0')
      .description("The bind address to listen to")

    optional(:format)
      .filled(:string, included_in?: ['auto', 'raw', 'json'])
      .default('auto')
      .description("Decoding format of data. 'auto' use extension files to determine the right format")
  end

  def initialize()
    super("tcp")
  end

  def raw(parser, params)
    if parser === :fluentd
      conversion = %{
      <source>
        @type tcp
        port #{params[:port]}
        bind #{params[:bind]}
        tag #{params[:tag]}
        <parse>
          @type #{params[:format] === 'auto' || params[:format] === 'raw' ? 'none' : params[:format]}
        </parse>
      </source>
    }

      return conversion
    else
      ""
    end
  end
end