class CreateBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :address
      t.string :coordinates

      t.timestamps
    end
    add_index :buildings, :name, unique: true
  end
end
