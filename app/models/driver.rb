class Driver < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
  validates :gender, presence: true
  validates_with DriverValidator

  has_many :driver_license, dependent: :destroy
  has_many :truck, dependent: :destroy


end