class DriverLicense < ApplicationRecord
  belongs_to :driver
  validates :category, presence: true
  validates :expiration_date, presence: true
  validates :driver, presence: true

  default_scope { where("expiration_date >= #{ Time.now.strftime("%F") } and status = 'ACTIVE'")}

  def disable
    self.status = :INACTIVE
  end
end
