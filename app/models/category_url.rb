class CategoryUrl < ApplicationRecord
  def self.last_parsed_recently?(url)
    category_url = find_by(url: url)
    category_url&.last_parsed_at&.> 3.hours.ago
  end
end
