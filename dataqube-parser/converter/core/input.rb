require_relative './plugin'

module Dataqube
  class Input < Dataqube::Plugin
    plugin_desc "Read data from specific source using one of the following plugins:"

    plugin_config do
      required(:tag).filled(:string).description("Which tag to apply to your input data")
    end

    def initialize(name)
      super('input', name)
    end
  end
end