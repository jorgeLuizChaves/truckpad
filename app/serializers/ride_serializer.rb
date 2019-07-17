class RideSerializer
  include FastJsonapi::ObjectSerializer
  attributes :origin_lat, :origin_lng, :destination_lat, :destination_lng, :status, :comeback_load
end
