require 'faraday'
require 'faraday_middleware'
require 'nokogiri'
require 'archive_today/version'
require 'archive_today/archiver'

module ArchiveToday
  class Error < StandardError; end

  class << self
    def capture(url:, debug: false)
      Archiver.new(url: url, debug: debug).capture
    end
  end
end
