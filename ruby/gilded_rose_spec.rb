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

  context 'when the item name is Aged Brie' do
    let(:items) { [Item.new('Aged Brie', sell_in, quality)] }
    let(:sell_in) { 10 }

    context 'when the quality is under 50' do
      let(:quality) { 20 }

      it 'increases the quality of the item' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 21
      end
    end

    context 'when the quality is 50 or over' do
      let(:quality) { 50 }

      it 'does not change the quality' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end
    end
  end

  context 'when the item name indicates a Backstage pass' do
    let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)] }
    let(:quality) { 10 }

    context 'when the sell in is greater than 10' do
      let(:sell_in) { 12 }

      it 'increases the quality by one' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 11
      end
    end

    context 'when the sell in day is between 4 and 10' do
      let(:sell_in) { 10 }

      it 'increases the quality by two' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 12
      end
    end

    context 'when the sell in day is between 3 and 1' do
      let(:sell_in) { 3 }

      it 'increases the quality by three' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 13
      end
    end

    context 'when the sell in day is zero or less' do
      let(:sell_in) { 0 }

      it 'sets the quality equal to 0' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end
    end
  end

  context 'when the item name is Sulfuras, Hand of Ragnaros' do
    let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', 5, 80)] }

    it 'does not effect the quality' do
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 80
    end

    it 'does not effect the sell in' do
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 5
    end
  end

  context 'when the item name is Conjured Mana Cake' do
    let(:items) { [Item.new('Conjured Mana Cake', sell_in, quality)] }

    context 'when the sell-in day is above 0' do
      let(:sell_in) { 10 }
      let(:quality) { 20 }

      it 'reduces the quality by two' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 18
      end
    end

    context 'when the sell-in day is at or below 0' do
      let(:sell_in) { -1 }
      let(:quality) { 20 }

      it 'reduces the quality by four' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 16
      end
    end

    context 'when the quality is 0' do
      let(:sell_in) { 5 }
      let(:quality) { 0 }

      it 'does not alter the quality' do
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
