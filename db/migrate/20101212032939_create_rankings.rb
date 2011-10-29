class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.date :ranking_date
      t.integer :rakuten_item_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end
