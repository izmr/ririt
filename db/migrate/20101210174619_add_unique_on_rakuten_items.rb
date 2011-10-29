class AddUniqueOnRakutenItems < ActiveRecord::Migration
  def self.up
    add_index :rakuten_items, [:shop_name, :item_name], {:name => :shop_item_idx, :unique => true}
  end

  def self.down
    remove_index :rakuten_items, [:shop_name, :item_name]
  end
end
