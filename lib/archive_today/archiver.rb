require 'faraday'
require 'faraday_middleware'
require 'nokogiri'
require_relative 'version'

module ArchiveToday
  class Archiver
    BASE_URL = 'https://archive.today/'.freeze
    DEFAULT_USER_AGENT = "archive_today #{ArchiveToday::VERSION}".freeze

    attr_reader :debug, :url, :user_agent

    def initialize(url:, user_agent: DEFAULT_USER_AGENT, debug: false)
      @debug = debug
      @url = url
      @user_agent = user_agent
    end

    def submit
      puts 'Submitting URL ...'
      response = connection.post('/submit/') do |req|
        req.body = submission_body
      end
      raise unless response.success?

      handle_response(response)
    end

    private

    def handle_response(response)
      headers = response.headers

      return headers[:location] if headers.has_key?('location')
      return headers[:refresh].split(';url=').last if headers.has_key?('refresh')

      # TODO: handle the history case mentioned here?
      # https://github.com/pastpages/archiveis/blob/master/archiveis/api.py#L81
      response.env.url
    end

    def submission_body
      URI.encode_www_form(
        {
          url: url,
          anyway: 1,
          submitid: unique_submission_id
        }
      )
    end

    def unique_submission_id
      puts 'Getting unique submission ID ...'
      response = connection.get('/')
      raise unless response.success?

      html = Nokogiri::HTML(response.body)
      node = html.at_css('input[name="submitid"]')
      id = node.attr('value')
      puts "Got ID: #{id}" and return if id

      nil
    end

    def connection
      @connection ||= begin
        Faraday.new(BASE_URL) do |faraday|
          faraday.headers = { 'User-Agent' => user_agent }
          faraday.use FaradayMiddleware::FollowRedirects
          faraday.response :logger if debug
        end
      end
    end
  end
end
