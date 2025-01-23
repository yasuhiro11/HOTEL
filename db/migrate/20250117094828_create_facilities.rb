class CreateFacilities < ActiveRecord::Migration[6.1]
  def change
    create_table :facilities do |t|
      t.string :name
      t.text :description
      t.string :location
      t.integer :price

      t.timestamps
    end
  end
end
