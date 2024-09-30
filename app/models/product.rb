class Product < ApplicationRecord
  include PgSearch::Model
  has_many :prices, dependent: :destroy
  pg_search_scope :search_by_name_or_url, against: [:name, :url], using: { tsearch: { prefix: true } }
end
