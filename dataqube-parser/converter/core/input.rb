require_relative './plugin'

module Dataqube
  class Input < Dataqube::Plugin
    def initialize(name)
      super('input', name)
    end
  end
end