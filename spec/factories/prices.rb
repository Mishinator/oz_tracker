FactoryBot.define do
  factory :price do
    price { 9.99 }
    product
    created_at { Time.now }
    updated_at { Time.now }
  end
end
