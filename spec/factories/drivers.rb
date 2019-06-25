FactoryBot.define do
  factory :driver do
    sequence(:name) {|n| "driver-#{n}"}
    age {39}
    gender {:MALE}
  end
end
