FactoryBot.define do
  factory :order_shipping_address do
    token          { "tok_#{Faker::Alphanumeric.alphanumeric(number: 28)}" }
    postcode       { "#{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}" }
    prefecture_id  { Faker::Number.between(from: 2, to: 48) }
    city           { Faker::Address.city }
    block          { Faker::Address.street_address }
    building       { Faker::Address.secondary_address }
    phone_number   { Faker::Number.number(digits: 11).to_s }

  end
end