class CreateTrucks < ActiveRecord::Migration[5.2]
  def change
    create_table :trucks do |t|
      t.string :category
      t.string :model
      t.string :brand
      t.boolean :is_loaded
      t.boolean :driver_owner

      t.timestamps
    end
  end
end
