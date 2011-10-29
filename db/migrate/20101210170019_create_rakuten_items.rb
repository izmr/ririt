class CreateRakutenItems < ActiveRecord::Migration
  def self.up
    create_table :rakuten_items do |t|
      t.string :shop_name
      t.string :item_name
      t.string :item_code
      t.string :title
      t.string :image_url

      t.timestamps
    end
  end

  def self.down
    drop_table :rakuten_items
  end
end
