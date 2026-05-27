# Layer - Infrastructure / Database Schema

class CreateStations < ActiveRecord::Migration[7.1]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.string :crs_code, null: false
      t.string :city, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.timestamps
    end

    add_index :stations, :crs_code, unique: true
    add_index :stations, :name
  end
end