require_relative '../../../core/input'

class Tail < Dataqube::Input
  config_param :path, :string

  def initialize()
    super("tail")
  end

  def raw(parser, params)
    if parser === :fluentd
      "
      <source>
        @type tail
        path #{params[:path]}
        tag #{params[:tag]}
        read_from_head true
        <parse>
          @type none
        </parse>
      </source>
    "
    else
      ""
    end
  end
end