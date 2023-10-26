require_relative './plugin'

module Dataqube
  class Transformer < Dataqube::Plugin
    plugin_desc "Transform your data using one of the following plugins:"

    def initialize(name)
      super('transformer', name)
    end
  end
end