FactoryBot.define do
  factory :category_url do
    url { "https://oz.by/category/sample" }
    last_parsed_at { Time.current }
   end
end
