require 'net/http'
require 'json'

HOST = 'http://localhost:3001'

module Dataqube
  class Api
    def initialize()
    end

    def get_project(project_id)
      url = "#{HOST}/api/project"

      params = { projectId: project_id }
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

    def begin_injection(project_id, version = 'last')
      url = "#{HOST}/api/project/_begin_injection"

      uri = URI.parse(url)
      body = { projectId: project_id, version: version }
      header = {'Content-Type': 'application/json'}
      response = Net::HTTP.post(uri, body.to_json, header)
      data = JSON.parse(response.body)
      return data['injectionId']
    end

    def end_injection(injection_id, status)
      url = "#{HOST}/api/project/_end_injection"

      uri = URI.parse(url)
      body = { injectionId: injection_id, status: status }
      header = {'Content-Type': 'application/json'}
      Net::HTTP.post(uri, body.to_json, header)
    end
  end
end