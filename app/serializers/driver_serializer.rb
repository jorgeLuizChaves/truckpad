class DriverSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :age, :gender
end
