class CreateCategoryUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :category_urls do |t|
      t.string :url
      t.datetime :last_parsed_at

      t.timestamps
    end
  end
end
