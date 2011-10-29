class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.integer :count, :default => 0

      t.timestamps
    end
    add_index :tags, :name
    add_index :tags, :count
  end

  def self.down
    drop_table :tags
  end
end
