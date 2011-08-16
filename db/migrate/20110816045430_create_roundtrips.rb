class CreateRoundtrips < ActiveRecord::Migration
  def self.up
    create_table :roundtrips do |t|
      t.integer :open_id
      t.integer :close_id

      t.timestamps
    end
  end

  def self.down
    drop_table :roundtrips
  end
end
