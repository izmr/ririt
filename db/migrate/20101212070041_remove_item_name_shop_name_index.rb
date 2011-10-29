class RemoveItemNameShopNameIndex < ActiveRecord::Migration
  def self.up
    remove_index(:rakuten_items, :name => :shop_item_idx)
  end

  def self.down
    add_index(:rakuten_items, [:shop_name, :item_name], {:unique=>true,:name=>:shop_item_idx})
  end
end
