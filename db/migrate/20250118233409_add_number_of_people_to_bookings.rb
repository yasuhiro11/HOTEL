class AddNumberOfPeopleToBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :number_of_people, :integer, null: false, default: 1
  end
end
