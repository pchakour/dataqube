require_relative './plugin'

module Dataqube
  class Assertion < Dataqube::Plugin
    plugin_desc "Check and validate your data using one of the following plugins:"

    desc "Message to store when assert event"
    config_param :message, :string, default: nil
    desc "Severity of the assertion"
    config_param :severity, ['fatal', 'major', 'minor', 'info'], default: 'info'
    desc "Indicate if you expect the check failed or succeed"
    config_param :expected, ['failure', 'success'], default: 'success'

    def initialize(name)
      super('assertion', name)
    end
  end
end