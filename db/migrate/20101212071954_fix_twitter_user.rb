class FixTwitterUser < ActiveRecord::Migration
  def self.up
    add_index(:twitter_users, :user_id, {:unique => true})
    add_index(:twitter_users, :username, {:unique => true})
  end

  def self.down
    remove_index(:twitter_users, :user_id)
    remove_index(:twitter_users, :username)
  end
end
