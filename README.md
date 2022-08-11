# KanjiToKatakana

Kanji to Katakana translator, based on [Kakasi](http://kakasi.namazu.org/).

It's a native gem, but it's pre-compiled for the following architectures:

+ x86_64-linix
+ aarch64-linix
+ x86_64-darwin
+ arm64-darwin

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanji_to_katakana'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kanji_to_katakana

## Usage

```ruby
require 'kanji_to_katakana'

KanjiToKatakana.kanji_to_katakana('岡川1796, 8701131, 大分県大分市, JAPAN')
# => 'オカカワ1796, 8701131, オオイタケンオオイタシ, JAPAN'

KanjiToKatakana.kanji_to_katakana('non-kanji')
# => 'non-kanji'
```

## Development

1. Clone the repo
2. Run `bundle install`
3. Run `rake compile` to download Kakasi, build and compile it, and compile the gem
4. Run `rspec` to run tests
5. Run `PLATFORM=<rubygems platform> rake build_native` to get a `.gem` file

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kanji_to_katakana.
