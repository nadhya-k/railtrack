# Layer - Test Infrastructure / Factories

FactoryBot.define do
  factory :station do
    name { Faker::Address.city + ' Central' }
    crs_code { generate(:crs_code) }
    city { Faker::Address.city }
  end

  factory :journey do
    association :origin,      factory: :station
    association :destination, factory: :station
    service_code { "VT#{Faker::Number.number(digits: 4)}" }
    departs_at { 1.hour.from_now }
    arrives_at { 3.hours.from_now }
    operator { 'Avanti West Coast' }
  end

  factory :fare do
    association :journey
    fare_type { Fare::FARE_TYPES.sample }
    price_pence { Faker::Number.between(from: 1000, to: 30_000) }
    is_flexible { false }
  end

  factory :booking do
    association :fare
    reference { ReferenceGenerator.generate }
    status { 'confirmed' }
  end

  factory :passenger do
    association :booking
    name { Faker::Name.full_name }
    railcard { nil }
  end

  sequence(:crs_code) do |n|
    letters = ('AAA'..'ZZZ').to_a
    letters[n % letters.size]
  end
end