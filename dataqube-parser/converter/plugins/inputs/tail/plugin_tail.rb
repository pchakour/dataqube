require_relative '../../../core/input'

class Tail < Dataqube::Input
  plugin_desc "Tail files from a specific path"
  plugin_license "community"

  desc "Path of fields to read. Wildcards are allowed to target multiple files"
  config_param :path, :string
  desc "Decoding format of files. 'auto' use extension files to determine the right format"
  config_param :format, ['auto', 'raw', 'json'], default: 'auto'

  def initialize()
    super("tail")
  end

  def raw(parser, params)
    if parser === :fluentd
      conversion = "
      <source>
        @type tail
        path #{params[:path]}
        tag #{params[:tag]}
        read_from_head true
        path_key filepath
        <parse>
          @type #{params[:format] === 'auto' || params[:format] === 'raw' ? 'none' : params[:format]}
        </parse>
      </source>
    "

      if params[:format] === 'auto'
        conversion << "
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
      end
      return conversion
    else
      ""
    end
  end
end