require 'archive_today/version'
require 'archive_today/archiver'

module ArchiveToday
  class Error < StandardError; end

  class << self
    def submit(url:, debug: false)
      Archiver.new(url: url, debug: debug).submit
    end
  end
end
