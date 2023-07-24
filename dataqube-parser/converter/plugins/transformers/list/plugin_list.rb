require_relative '../../../core/transformer'

class List < Dataqube::Transformer
  plugin_desc "Parse a serialized list"
  plugin_license "community"

  desc "Source field to parse"
  config_param :source, :string, default: 'message'
  desc """
    Target field to store parsed data. By default, the parsed data will be merged with the target field.
    If no target is provided, the source field will be used.
  """
  config_param :target, :string, default: nil
  desc "Change the default behavior that merge parsed data with target. True will replace the target field value by the parsed data"
  config_param :overwrite, :boolean, default: false

  def initialize()
    super("list")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    source = params[:source]
    target = params[:target]
    overwrite = params[:overwrite]
    target_output = "record = merge_hash(record, list)"
    if target
      if overwrite
        target_output = "#{record(target)} = list"
      else
        target_output = "#{record(target)} = merge_hash(#{record(target)}, list)"
      end
    end

    %{
      list = parse_list(#{record(source)})
      #{target_output}
    }
  end
end