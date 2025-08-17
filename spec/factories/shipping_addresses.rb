FactoryBot.define do
  factory :shipping_address do
    postcode { "MyString" }
    prefecture_id { 1 }
    city { "MyString" }
    block { "MyString" }
    building { "MyString" }
    phone_number { "MyString" }
    order { nil }
  end
end
