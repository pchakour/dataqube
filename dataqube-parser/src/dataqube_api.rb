require 'net/http'
require 'json'

HOST = 'http://localhost:3001'

module Dataqube
  class Api
    def initialize()
    end

    def get_project(project_id)
      url = "#{HOST}/api/project"

      params = { id: project_id }
      uri = URI(url + '?' + URI.encode_www_form(params))

      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      return data
    end

    def get_rules(rules_id)
      url = "#{HOST}/api/rule"

      params = { id: rules_id }
      uri = URI(url + '?' + URI.encode_www_form(params))

      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      return data
    end
  end
end