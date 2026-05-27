# Layer - Infrastructure / Database Schema

class CreatePassengers < ActiveRecord::Migration[7.1]
  def change
    create_table :passengers do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :name,     null: false
      t.string :railcard
      t.timestamps
    end

    add_index :passengers, :booking_id
  end
end