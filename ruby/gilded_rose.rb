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
    default = -> { DefaultUpdater }
    [BrieUpdater, BackstageUpdater, ItemUpdater, ConjuredUpdater]
      .find(default) { |updater| updater.handles?(item.name) }
      .new(item)
  end

  def self.handles?(name)
    name == self::NAME
  end

  def initialize(item)
    @item = item
  end

  NAME = 'Sulfuras, Hand of Ragnaros'

  def update; end

  private

  attr_reader :item
end

# update brie items
class BrieUpdater < ItemUpdater
  NAME = 'Aged Brie'

  def update
    item.sell_in -= 1
    item.quality += 1 unless item.quality >= 50
  end
end

# update backstage items
class BackstageUpdater < ItemUpdater
  NAME = 'Backstage passes to a TAFKAL80ETC concert'

  def update
    item.sell_in -= 1
    return if item.quality >= 50

    return item.quality = 0 if item.sell_in <= 0

    item.quality += case item.sell_in
                    when 1..3 then 3
                    when 4..10 then 2
                    else 1
                    end
  end
end

# update default item
class DefaultUpdater < ItemUpdater
  def self.handles?(_name) = true

  def update
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0 && item.quality.positive?
  end
end

# new conjured item updater
class ConjuredUpdater < ItemUpdater
  NAME = 'Conjured Mana Cake'

  def update
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 2
    item.quality -= 2 if item.sell_in <= 0
    item.quality = 0 if item.quality <= 0
  end
end
