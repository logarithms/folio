class AddPositionCdToTrades < ActiveRecord::Migration
  def self.up
    add_column :trades, :position_cd, :integer
  end

  def self.down
    remove_column :trades, :position_cd
  end
end
