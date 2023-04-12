require_relative './plugin'

module Dataqube
  class Extractor < Dataqube::Plugin
    def initialize(name)
      super("extractor", name)
    end
  end
end