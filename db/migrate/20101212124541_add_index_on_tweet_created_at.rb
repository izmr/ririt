class AddIndexOnTweetCreatedAt < ActiveRecord::Migration
  def self.up
    add_index(:tweets, :created_at)
  end

  def self.down
    remove_index(:tweets, :created_at)
  end
end
