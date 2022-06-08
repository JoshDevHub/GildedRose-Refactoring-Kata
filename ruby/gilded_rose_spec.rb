# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'gilded_rose')

# rubocop:disable Metrics/BlockLength
describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    context 'when the item does not map to a specific type' do
      let(:items) { [Item.new('foo', sell_in, quality)] }

      context 'when the sell in day is above 0' do
        let(:quality) { 20 }
        let(:sell_in) { 10 }

        it 'reduces the item quality by one' do
          GildedRose.new(items).update_quality
          expect(items[0].quality).to eq 19
        end

        it 'reduces the sell-in day by one' do
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq 9
        end
      end

      context 'when the sell in day is less than or equal to 0' do
        let(:quality) { 20 }
        let(:sell_in) { 0 }

        it 'reduces the quality by two' do
          GildedRose.new(items).update_quality
          expect(items[0].quality).to eq 18
        end
      end

      context 'when the quality is 0' do
        let(:quality) { 0 }
        let(:sell_in) { 10 }

        it 'does not change the quality' do
          GildedRose.new(items).update_quality
          expect(items[0].quality).to eq 0
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
