class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.integer :qty
      t.integer :trade_id

      t.timestamps
    end
  end

  def self.down
    drop_table :executions
  end
end
