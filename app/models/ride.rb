class Ride < ApplicationRecord
  belongs_to :driver
  validates :origin_lat, presence: true
  validates :origin_lng, presence: true
  validates :destination_lat, presence: true
  validates :destination_lng, presence: true
end
