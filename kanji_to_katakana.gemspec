# frozen_string_literal: true

require_relative 'lib/kanji_to_katakana/version'

if File.exists?('lib/kanji_to_katakana.bundle')
  dylib = 'lib/kanji_to_katakana.bundle'
elsif File.exists?('lib/kanji_to_katakana.so')
  dylib = 'lib/kanji_to_katakana.so'
else
  dylib = 'mising-dylib'
end

spec = Gem::Specification.new do |spec|
  spec.name = 'kanji_to_katakana'
  spec.version = KanjiToKatakana::VERSION
  spec.authors = ['Ilya Bylich']
  spec.email = ['ibylich@gmail.com']

  spec.summary = 'Kanji to Katakana converter built on top of Kakasi.'
  spec.required_ruby_version = '>= 2.6.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = [
    'lib/kanji_to_katakana/itaijidict',
    'lib/kanji_to_katakana/kanwadict',
    'lib/kanji_to_katakana/platform.rb',
    'lib/kanji_to_katakana/version.rb',
    dylib,
    'lib/kanji_to_katakana.rb',
    'kanji_to_katakana.gemspec',
    'README.md',
  ]
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
