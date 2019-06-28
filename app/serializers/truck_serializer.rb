class TruckSerializer
  include FastJsonapi::ObjectSerializer
  attributes :category, :model, :brand, :is_loaded, :driver_owner
end
