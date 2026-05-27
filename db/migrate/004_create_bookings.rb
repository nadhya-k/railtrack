# Layer - Infrastructure / Database Schema

class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :fare,      null: false, foreign_key: true
      t.string     :reference, null: false
      t.string     :status,    null: false, default: 'confirmed'
      t.timestamps
    end

    add_index :bookings, :reference, unique: true
    add_index :bookings, :status
  end
end