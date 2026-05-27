# Layer - Infrastructure / Database Schema

# This file sets price to store as integer pence and not float i.e £35.00 = 3500.


class CreateFares < ActiveRecord::Migration[7.1]
  def change
    create_table :fares do |t|
      t.references :journey,    null: false, foreign_key: true
      t.string  :fare_type,     null: false
      t.integer :price_pence,   null: false
      t.boolean :is_flexible,   null: false, default: false
      t.integer :available_seats
      t.timestamps
    end

    add_index :fares, %i[journey_id fare_type]
    add_index :fares, :price_pence
  end
end