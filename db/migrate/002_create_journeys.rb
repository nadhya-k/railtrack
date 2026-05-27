# Layer - Infrastructure / Database Schema


class CreateJourneys < ActiveRecord::Migration[7.1]
  def change
    create_table :journeys do |t|
      t.references :origin, null: false, foreign_key: { to_table: :stations }
      t.references :destination, null: false, foreign_key: { to_table: :stations }
      t.string   :service_code, null: false
      t.datetime :departs_at, null: false
      t.datetime :arrives_at, null: false
      t.string   :operator, null: false
      t.boolean  :has_live_updates, null: false, default: false
      t.timestamps
    end

    add_index :journeys, %i[origin_id destination_id departs_at]
    add_index :journeys, :service_code
  end
end