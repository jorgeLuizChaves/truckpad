class RideSerializer
  include FastJsonapi::ObjectSerializer
  attributes :origin_lat, :origin_lng, :destination_lat, :destination_lng, :status
end
