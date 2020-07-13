# ArchiveToday

A simple Ruby wrapper for the [Archive.today](https://archive.today) web capture service (formerly known as Archive.is)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'archive_today'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install archive_today

## Usage

### Class Method

`ArchiveToday#capture`

Returns a Hash with keys `:url` and `:screenshot_url`. Note that if the page is in the process of being archived, the screenshot is not generated yet, so `nil` is returned for the screenshot URL.

#### Args

- `url` (required) - the target URL for archival
- `debug` (optional) - when set to true, this will log HTTP requests and responses

```ruby
require 'archive_today'

ArchiveToday.capture(url: 'https://example.com')

# => { url: 'https://archive.is/a1b2c3, screenshot_url: 'https://archive.is/[...].jpg' }
```

### Instance Method

`ArchiveToday::Archiver`

This class exposes the same `#capture` method, but you can also query the instance for the cached URLs once the capture response is received.

#### Args

- `url` (required) - the target URL for archival
- `debug` (optional) - when set to true, this will log HTTP requests and responses


```ruby
require 'archive_today'

a = ArchiveToday::Archiver.new(url: 'https://example.com')
a.capture

puts a.screenshot_url

# => 'https://archive.is/[...].jpg
```

## Roadmap

- proxies

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomholford/archive_today.

## Credit

Inspired by [this Python implementation](https://github.com/pastpages/archiveis), thanks to those contributors.