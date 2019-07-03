class CreateRides < ActiveRecord::Migration[5.2]
  def change
    create_table :rides do |t|
      t.string :status
      t.boolean :comeback_load
      t.references :driver, foreign_key: true
      t.string :origin
      t.float :origin_lat
      t.string :origin_lng
      t.string :destination
      t.float :destination_lat
      t.float :destination_lng

      t.timestamps
    end
  end
end
