require_relative './plugin'

module Dataqube
  class Assertion < Dataqube::Plugin
    def initialize(name)
      super('assertion', name)
    end
  end
end