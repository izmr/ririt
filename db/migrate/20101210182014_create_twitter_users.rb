class CreateTwitterUsers < ActiveRecord::Migration
  def self.up
    create_table :twitter_users do |t|
      t.integer :user_id
      t.string :profile_image_url
      t.string :username

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_users
  end
end
