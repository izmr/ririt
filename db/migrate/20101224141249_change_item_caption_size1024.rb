class ChangeItemCaptionSize1024 < ActiveRecord::Migration
  def self.up
    change_column(:rakuten_items, :item_caption, :string, :limit => 1024)
  end

  def self.down
    change_column(:rakuten_items, :item_caption, :string, :limit => 512)
  end
end
