class AddStatusToDriver < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :status, :string, :default => :ACTIVE
  end
end
