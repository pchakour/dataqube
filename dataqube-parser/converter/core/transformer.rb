require_relative './plugin'

module Dataqube
  class Transformer < Dataqube::Plugin
    def initialize(name)
      super('transformer', name)
    end
  end
end