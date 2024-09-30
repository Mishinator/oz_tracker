FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    url { "https://oz.by/books/sample-product.html" }

    after(:create) do |product|
      create(:price, product: product)
    end
  end
 end
