FactoryBot.define do
  factory :driver_license do
    category { :C }
    expiration_date { "2020-06-25" }
    association :driver
  end
end
