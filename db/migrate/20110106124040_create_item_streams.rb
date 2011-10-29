class CreateItemStreams < ActiveRecord::Migration
  def self.up
    create_table :item_streams do |t|
      t.integer :rakuten_item_id
      t.integer :point

      t.timestamps
    end
    add_index :item_streams, :rakuten_item_id
    add_index :item_streams, :point
    add_index :item_streams, :updated_at
  end

  def self.down
    drop_table :item_streams
  end
end
