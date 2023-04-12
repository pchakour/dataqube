require_relative './plugin'

module Dataqube
  class Output < Dataqube::Plugin
    def initialize(name)
      super('output', name)
    end
  end
end