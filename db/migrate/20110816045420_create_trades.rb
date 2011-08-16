class CreateTrades < ActiveRecord::Migration
  def self.up
    create_table :trades do |t|
      t.string :ameritradeid
      t.string :symbol
      t.date :date
      t.integer :qty
      t.float :amount
      t.integer :action_cd
      t.integer :state_cd

      t.timestamps
    end
  end

  def self.down
    drop_table :trades
  end
end
