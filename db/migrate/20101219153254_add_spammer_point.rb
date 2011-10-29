class AddSpammerPoint < ActiveRecord::Migration
  def self.up
    add_column(:twitter_users, :spammer_point, :integer)
  end

  def self.down
    remove_column(:twitter_users, :spammer_point)
  end
end
