class Truck < ApplicationRecord
  belongs_to :driver
  validates :category, presence: true
  validates :driver_owner, inclusion: { in: [true, false] }
  validates :driver_owner, exclusion: { in: [nil] }
  validates_with TruckValidator
end
