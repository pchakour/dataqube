require_relative './plugin'

module Dataqube
  class Assertion < Dataqube::Plugin
    config_param :message, :string, default: nil
    config_param :severity, ['fatal', 'major', 'minor', 'info'], default: 'info'

    def initialize(name)
      super('assertion', name)
    end
  end
end