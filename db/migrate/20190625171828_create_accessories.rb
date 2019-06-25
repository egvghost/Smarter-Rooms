class CreateAccessories < ActiveRecord::Migration[5.2]
  def change
    create_table :accessories do |t|
      t.string :name
      t.timestamps
    end
    create_table :accessories_rooms, id: false do |t|
      t.belongs_to :accessory
      t.belongs_to :room
    end
    add_index :accessories, :name, unique: true
  end
end
