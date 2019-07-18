class DriverLicenseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :category, :expiration_date
  belongs_to :driver, lazy_load_data: false, links: {
      related: -> (object) {
        "/drivers/#{object.driver.id}"
      }
  }
end