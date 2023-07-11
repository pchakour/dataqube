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
        path_key filepath
        <parse>
          @type none
        </parse>
      </source>
      <filter *>
        @type dataqube
        init ''
        code \"${
          if record.key?('filepath') && record['filepath'].end_with?('.json')
            json_result = parse_json(record['message'])
            record = merge_hash(record, json_result)
            record['message'] = json_result['message']
          end
          record
        }\"
      </filter>
    "
    else
      ""
    end
  end
end