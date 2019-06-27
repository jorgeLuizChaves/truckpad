class DriverSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :age, :gender
  has_many :driver_license, lazy_load_data: false, links: {
      related: -> (object) {
        "/drivers/#{object.id}/licenses"
      }
  }
  has_many :truck, lazy_load_data: false, links: {
      related: -> (object) {
        "/drivers/#{object.id}/truck"
      }
  }
end
