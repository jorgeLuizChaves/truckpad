class AddDriverToTruck < ActiveRecord::Migration[5.2]
  def change
    add_reference :trucks, :driver, foreign_key: true
  end
end
