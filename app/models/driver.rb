class Driver < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
  validates :gender, presence: true
  validates_with DriverValidator

  has_many :driver_license, dependent: :destroy
  has_many :truck, dependent: :destroy
  has_many :rides

  scope :owner_truck, ->(owner) { Driver.joins(:truck).where(trucks: {driver_owner: owner})}

  default_scope -> { where(status: :ACTIVE)}

end