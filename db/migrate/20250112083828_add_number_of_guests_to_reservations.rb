class AddNumberOfGuestsToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :number_of_guests, :integer,null: false, default: 1
  end
end
