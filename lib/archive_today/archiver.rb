require_relative 'version'

module ArchiveToday
  class Archiver
    BASE_URL = 'https://archive.today/'.freeze
    DEFAULT_USER_AGENT = "archive_today #{ArchiveToday::VERSION}".freeze

    attr_accessor :response
    attr_reader :debug, :target_url, :user_agent

    def initialize(url:, user_agent: DEFAULT_USER_AGENT, debug: false)
      @debug = debug
      @target_url = url
      @user_agent = user_agent
    end

    def capture
      puts 'Submitting URL ...' if debug
      response = connection.post('/submit/') do |req|
        req.body = submission_body
      end
      raise unless response.success?

      self.response = response

      {
        url: finalized_url,
        screenshot_url: screenshot_url
      }
    end

    private

    def finalized_url
      archived_url.gsub('/wip', '')
    end

    def archived_url
      @archived_url ||= begin
        headers = response.headers

        return headers[:location] if headers.has_key?('location')
        return headers[:refresh].split(';url=').last if headers.has_key?('refresh')

        # TODO: handle the history case mentioned here?
        # https://github.com/pastpages/archiveis/blob/master/archiveis/api.py#L81
        response.env.url
      end
    end

    def screenshot_url
      return nil unless archived_url
      return nil if archived_url.include? '/wip/'

      response = connection.get do |req|
        req.url "#{archived_url}/image"
      end
      html = Nokogiri::HTML(response.body)
      node = html.at_css('img[itemprop="contentUrl"]')
      url = node.attr('src')
      puts "Got screenshot URL: #{url}" if debug && url
      return url if url

      nil
    end

    def submission_body
      URI.encode_www_form(
        {
          url: target_url,
          anyway: 1,
          submitid: unique_submission_id
        }
      )
    end

    def unique_submission_id
      puts 'Getting unique submission ID ...' if debug
      response = connection.get('/')
      raise unless response.success?

      html = Nokogiri::HTML(response.body)
      node = html.at_css('input[name="submitid"]')
      id = node.attr('value')
      puts "Got ID: #{id}" if debug && id
      return id if id

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
