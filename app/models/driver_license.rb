class DriverLicense < ApplicationRecord
  belongs_to :driver
  validates :type, presence: true
  validates :expiration_date, presence: true
  validates :driver, presence: true
end
