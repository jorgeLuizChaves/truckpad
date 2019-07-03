FactoryBot.define do
  factory :ride do
    status { :IN_PROGRESS }
    comeback_load { false }
    origin { "Origin" }
    origin_lat { 1.5 }
    origin_lng { 1.5 }
    destination { "Destination" }
    destination_lat { 1.5 }
    destination_lng { 1.5 }
    association :driver
  end
end
