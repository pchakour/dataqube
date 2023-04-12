require_relative '../../../core/transformer'

class List < Dataqube::Transformer
  config_param :source, :string, default: 'message'
  config_param :target, :string, default: 'message'
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
        target_output = "#{record(target)} = merge_hash(#{record(target)}, list)"
      else
        target_output = "#{record(target)} = list"
      end
    end

    %{
      list = parse_list(#{record(source)})
      #{target_output}
    }
  end
end