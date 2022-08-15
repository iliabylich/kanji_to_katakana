# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

require 'rake/clean'
CLEAN.include('lib/kanji_to_katakana.bundle')
CLEAN.include('lib/kanji_to_katakana.so')
CLEAN.include('lib/kanji_to_katakana/platform.rb')
CLEAN.include('lib/kanji_to_katakana/itaijidict')
CLEAN.include('lib/kanji_to_katakana/kanwadict')
CLEAN.include('kakasi-2.3.6.tar.gz')
CLEAN.include('kakasi-2.3.6')
CLEAN.include('tmp')
CLEAN.include('libkakasi.h')
CLEAN.include('libkakasi.a')

require 'rake/extensiontask'
Rake::ExtensionTask.new('kanji_to_katakana')
task spec: :compile



desc 'Build a package for PLATFORM'
task :build_native do
  raise 'PLATFORM env var must be set' unless ENV['PLATFORM']
  gemspec = 'kanji_to_katakana.gemspec'
  content = File.read(gemspec)
  version = Bundler.load_gemspec(gemspec).version.to_s

  File.write(gemspec, <<~RUBY, mode: 'a+')
    spec.platform = '#{ENV['PLATFORM']}'
    spec
  RUBY

  Rake::Task['build'].invoke

  sh("mv pkg/kanji_to_katakana-#{version}-#{ENV['PLATFORM']}.gem kanji_to_katakana-#{ENV['PLATFORM']}.gem")
ensure
  File.write(gemspec, content) if content
end
