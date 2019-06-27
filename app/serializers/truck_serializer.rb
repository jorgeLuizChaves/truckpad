class TruckSerializer
  include FastJsonapi::ObjectSerializer
  attributes :category, :model, :brand, :is_loaded, :driver_owner
  belongs_to :driver, lazy_load_data: false, links: {
      related: -> (object) {
        "/drivers/#{object.id}"
      }
  }
end
