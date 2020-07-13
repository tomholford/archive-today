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

```ruby
require 'archive_today'

ArchiveToday.submit(url: 'https://example.com')

# => 'https://archive.is/a1b2c3
```

## Roadmap

- proxies
- optionally return URL of captured screenshot

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomholford/archive_today.

## Credit

Inspired by [this Python implementation](https://github.com/pastpages/archiveis), thanks to those contributors.