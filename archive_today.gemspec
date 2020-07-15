require_relative 'lib/archive_today/version'

Gem::Specification.new do |spec|
  spec.name          = "archive_today"
  spec.version       = ArchiveToday::VERSION
  spec.authors       = ["tomholford"]
  spec.email         = ["tomholford@users.noreply.github.com"]

  spec.summary       = %q{A Ruby gem for submitting links to Archive.today (AKA Archive.is)}
  spec.description   = %q{Submit a URL to the Archive.today service to preserve it's contents in a Memento-compatible format}
  spec.homepage      = "https://github.com/tomholford/archive-today"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.add_dependency 'faraday', '~> 1.0'
  spec.add_dependency 'faraday_middleware', '~> 1.0'
  spec.add_dependency 'nokogiri', '~> 1.10'
  spec.add_dependency 'rake', '>= 12', '< 14'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
