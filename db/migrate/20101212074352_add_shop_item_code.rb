class AddShopItemCode < ActiveRecord::Migration
  def self.up
    add_column(:rakuten_items, :shop_item_code, :string)
    add_index(:rakuten_items, :shop_item_code, {:unique => true})
  end

  def self.down
    remove_column(:rakuten_items, :shop_item_code)
    remove_column(:rakuten_items, :column => [:shop_item_code])
  end
end
