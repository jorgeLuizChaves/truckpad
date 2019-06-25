class CreateDriverLicenses < ActiveRecord::Migration[5.2]
  def change
    create_table :driver_licenses do |t|
      t.string :type
      t.date :expiration_date
      t.references :driver, foreign_key: true

      t.timestamps
    end
  end
end
