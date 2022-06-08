# frozen_string_literal: true

# The Gilded Rose Kata
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      ItemUpdater.for(item).update
    end
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

# item updater class
class ItemUpdater
  def self.for(item)
    [BrieUpdater, BackstageUpdater, ItemUpdater, DefaultUpdater]
      .find { |updater| updater.handles?(item.name) }
      .new(item)
  end

  def self.handles?(name)
    name == 'Sulfuras, Hand of Ragnaros'
  end

  def initialize(item)
    @item = item
  end

  def update; end

  private

  attr_reader :item
end

# update brie items
class BrieUpdater < ItemUpdater
  def self.handles?(name)
    name == 'Aged Brie'
  end

  def update
    item.sell_in -= 1
    item.quality += 1 unless item.quality >= 50
  end
end

# update backstage items
class BackstageUpdater < ItemUpdater
  def self.handles?(name)
    name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def update
    item.sell_in -= 1
    sell_in = item.sell_in
    if sell_in <= 0
      item.quality = 0
      return
    end
    item.quality += 1
    item.quality += 1 if sell_in <= 10
    item.quality += 1 if sell_in <= 3
  end
end

# update default item
class DefaultUpdater < ItemUpdater
  def self.handles?(_name) = true

  def update
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0
  end
end
