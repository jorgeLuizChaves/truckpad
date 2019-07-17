class CreateRides < ActiveRecord::Migration[5.2]
  def change
    create_table :rides do |t|
      t.string :status, default: :CREATED
      t.boolean :comeback_load
      t.references :driver, foreign_key: true
      t.string :origin
      t.float :origin_lat
      t.float :origin_lng
      t.string :destination
      t.float :destination_lat
      t.float :destination_lng

      t.timestamps
    end
  end
end
