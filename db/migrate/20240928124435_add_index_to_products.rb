class AddIndexToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :name, using: :gin, opclass: { name: :gin_trgm_ops }
    add_index :products, :url, using: :gin, opclass: { url: :gin_trgm_ops }
  end
end
