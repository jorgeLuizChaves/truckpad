class AddStatusToTruck < ActiveRecord::Migration[5.2]
  def change
    add_column :trucks, :status, :string, :default => :ACTIVE
  end
end
