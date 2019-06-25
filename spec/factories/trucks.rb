FactoryBot.define do
  factory :truck do
    type { :TYPE_1 }
    model { "model" }
    brand { "brand" }
    is_loaded { false }
    driver_owner { false }
    association :driver
  end
end
