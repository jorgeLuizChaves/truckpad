class DriverLicenseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :category, :expiration_date
end