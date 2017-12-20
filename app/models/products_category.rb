class ProductsCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  validates :category_id, presence: true, uniqueness: { scope: :product_id, message: 'already has this product' }
  validate :product_belongs_to_deepest_category

  def self.get_product_ids_by(category_ids_collection)
    product_ids = where(category_id: category_ids_collection.first).pluck(:product_id).uniq

    category_ids_collection[1..-1].each do |categories_ids|
      product_ids = where(category_id: categories_ids, product_id: product_ids).pluck(:product_id).uniq
    end

    product_ids
  end

  def product_belongs_to_deepest_category
    errors.add(:base, 'Product must belong to the deepest category') if category.depth != Category::MAX_DEPTH
  end
end
