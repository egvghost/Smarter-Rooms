class AddAttendantsToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :attendants, :integer
  end
end
