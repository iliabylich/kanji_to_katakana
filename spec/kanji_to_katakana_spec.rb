# frozen_string_literal: true

RSpec.describe KanjiToKatakana do
  describe '.kanji_to_katakana' do
    context 'when given string is Kanji' do
      it 'converts it to Katakana' do
        expect(
          described_class.kanji_to_katakana('岡川1796, 8701131, 大分県大分市, JAPAN')
        ).to eq(
          'オカカワ1796, 8701131, オオイタケンオオイタシ, JAPAN'
        )
      end
    end

    context 'when given string is not Kanji' do
      it 'returns an argument' do
        expect(described_class.kanji_to_katakana('FOO')).to eq('FOO')
      end
    end
  end
end
