class AddItemPrice < ActiveRecord::Migration
  def self.up
    add_column(:rakuten_items, :item_price, :bigint, :limit=>20)
  end

  def self.down
    remove_column(:rakuten_items, :item_price)
  end
end
