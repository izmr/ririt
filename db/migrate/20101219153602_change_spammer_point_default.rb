class ChangeSpammerPointDefault < ActiveRecord::Migration
  def self.up
    change_column(:twitter_users, :spammer_point, :integer, {:default => 0})
  end

  def self.down
    change_column(:twitter_users, :spammer_point, :integer)
  end
end
