require_relative './plugin'

module Dataqube
  class Assertion < Dataqube::Plugin
    plugin_desc "Check and validate your data using one of the following plugins:"

    plugin_config do
      optional(:message)
        .filled(:string)
        .description("Message to store when assert event")

      optional(:severity)
        .filled(:string, included_in?: ['fatal', 'major', 'minor', 'info'])
        .default('info')
        .description("Severity of the assertion")

      optional(:expected)
        .filled(:string, included_in?: ['failure', 'success'])
        .default('success')
        .description("Indicate if you expect the check failed or succeed")
    end

    def initialize(name)
      super('assertion', name)
    end
  end
end