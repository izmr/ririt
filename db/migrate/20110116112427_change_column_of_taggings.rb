class ChangeColumnOfTaggings < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :rakuten_item_id, :tweet_id
  end

  def self.down
    rename_column :taggings, :tweet_id, :rakuten_item_id
  end
end
