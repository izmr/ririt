class AddSpammerCheck < ActiveRecord::Migration
  def self.up
    add_column(:rakuten_items, :spam_point, :integer)
    add_column(:tweets, :spam_point, :integer)
  end

  def self.down
    remove_column(:rakuten_items, :spam_point)
    remove_column(:tweets, :spam_point)
  end
end
