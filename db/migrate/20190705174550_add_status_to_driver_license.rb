class AddStatusToDriverLicense < ActiveRecord::Migration[5.2]
  def change
    add_column :driver_licenses, :status, :string, :default => :ACTIVE
  end
end
