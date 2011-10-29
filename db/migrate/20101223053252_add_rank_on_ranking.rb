class AddRankOnRanking < ActiveRecord::Migration
  def self.up
    add_column(:rankings, :rank, :integer)
  end

  def self.down
    remove_column(:rankings, :rank)
  end
end
