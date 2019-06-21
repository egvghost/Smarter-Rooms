class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.belongs_to :room
      t.timestamps
    end
    add_index :items, :name, unique: true
  end
end
