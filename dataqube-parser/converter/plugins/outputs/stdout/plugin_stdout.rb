require_relative '../../../core/output'

class Stdout < Dataqube::Output
  plugin_desc "Output data to stdout"
  plugin_license "community"

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