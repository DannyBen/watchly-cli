lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'watchly/version'

Gem::Specification.new do |s|
  s.name        = 'watchly-cli'
  s.version     = Watchly::VERSION
  s.summary     = 'Lightweight, polling-based file system watcher CLI'
  s.description = [
    'A small polling-based executable that watches one or more glob patterns',
    'and reports on change',
  ].join(' ')
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.executables = ['watchly']
  s.homepage    = 'https://github.com/dannyben/watchly-cli'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'colsole', '~> 1.0'
  s.add_dependency 'mister_bin', '~> 0.9'
  s.add_dependency 'watchly', '~> 0.1.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/watchly-cli/issues',
    'changelog_uri'         => 'https://github.com/dannyben/watchly-cli/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/watchly-cli',
    'rubygems_mfa_required' => 'true',
  }
end
