class AddDurationToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :duration, :float
  end
end
