class AddFacilityIdToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :facility_id, :integer
  end
end
