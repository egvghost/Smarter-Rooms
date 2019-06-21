class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :code
      t.integer :floor
      t.integer :max_capacity
      t.belongs_to :building
      t.timestamps
    end
    add_index :rooms, :name, unique: true
    add_index :rooms, :code, unique: true
  end
end
