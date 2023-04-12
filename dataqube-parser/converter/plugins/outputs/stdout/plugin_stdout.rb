require_relative '../../../core/output'

class Stdout < Dataqube::Output

  def initialize()
    super("stdout")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <match *>
        @type stdout
      </match>
    "
    else
      ""
    end
  end
end