require_relative './plugin'

module Dataqube
  class Extractor < Dataqube::Plugin
    plugin_desc "Extract fields from your data using one of the following plugins:"

    def initialize(name)
      super("extractor", name)
    end
  end
end