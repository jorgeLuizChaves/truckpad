class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
      rename_column :drivers, :sex, :gender
  end
end
