class AddIndexOnTheRelations < ActiveRecord::Migration
  def self.up
    add_index(:tweets, :twitter_user_id)
    add_index(:tweets, :rakuten_item_id)
  end

  def self.down
    remove_index(:tweets, :column => :twitter_user_id)
    remove_index(:tweets, :column => :rakuten_item_id)
  end
end
