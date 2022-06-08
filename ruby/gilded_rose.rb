# frozen_string_literal: true

# The Gilded Rose Kata
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        update_quality_for_brie(item)
      when 'Sulfuras, Hand of Ragnaros'
        update_quality_for_sulfras(item)
      when 'Backstage passes to a TAFKAL80ETC concert'
        update_quality_for_backstage(item)
      else
        update_quality_for_default(item)
      end
    end
  end

  private

  def update_quality_for_brie(item)
    item.sell_in -= 1
    item.quality += 1 unless item.quality >= 50
  end

  def update_quality_for_sulfras(item); end

  def update_quality_for_backstage(item)
    item.sell_in -= 1
    if item.sell_in <= 0
      item.quality = 0
      return
    end
    item.quality += 1
    item.quality += 1 if item.sell_in <= 10
    item.quality += 1 if item.sell_in <= 3
  end

  def update_quality_for_default(item)
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0
  end
end

# Item class / Don't touch!
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
