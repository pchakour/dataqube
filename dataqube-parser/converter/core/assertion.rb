require_relative './plugin'

module Dataqube
  class Assertion < Dataqube::Plugin
    config_param :message, :string, default: nil

    def initialize(name)
      super('assertion', name)
    end
  end
end