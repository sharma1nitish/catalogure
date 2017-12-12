class CreateProductsCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :products_categories do |t|
      t.references :product, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end

    add_index :products_categories, [:product_id, :category_id], unique: true
  end
end
