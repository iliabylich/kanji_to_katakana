# frozen_string_literal: true

require_relative 'kanji_to_katakana/version'

begin
  require_relative 'kanji_to_katakana/platform'
rescue LoadError
  raise 'The version of kanji_to_katakana that you are using is not precompiled'
end

case KanjiToKatakana::PLATFORM
when 'x86_64-apple-darwin', 'aarch64-apple-darwin'
  require_relative 'kanji_to_katakana.bundle'
when 'x86_64-unknown-linux-gnu', 'aarch64-unknown-linux-gnu'
  require_relative 'kanji_to_katakana.so'
else
  raise LoadError, "Unsupported platform #{KanjiToKatakana::PLATFORM.inspect}"
end
