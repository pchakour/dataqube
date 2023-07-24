require_relative './plugin'

module Dataqube
  class Input < Dataqube::Plugin
    plugin_desc "Read data from specific source using one of the following plugins:"

    def initialize(name)
      super('input', name)
    end
  end
end