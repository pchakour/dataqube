require_relative './plugin'

module Dataqube
  class Output < Dataqube::Plugin
    plugin_desc "Send your data to a specific destination using one of the following plugins:"

    def initialize(name)
      super('output', name)
    end
  end
end