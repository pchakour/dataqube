require_relative '../../../core/transformer'

class Split < Dataqube::Transformer
  plugin_license "community"
  plugin_desc "Split an event in several events based on the specified field"
  plugin_details """
::: warning
Limitation only one by tag and at the end of the transform section
:::
"""

  desc "Field to split in several events. You can specify an array"
  config_param :source, :string, multi: true

  def initialize()
    super("split")
  end

  def once(rule_tag, params)
    ""
  end

  def each(rule_tag, params)
    %{
      sources = #{params[:source].kind_of?(Array) ? params[:source].to_s.gsub('"', "'") : [params[:source]].to_s.gsub('"', "'")}
      record = split(record, sources)
    }
  end
end