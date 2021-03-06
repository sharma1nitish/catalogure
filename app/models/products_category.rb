class ProductsCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  validates :category_id, presence: true, uniqueness: { scope: :product_id, message: 'already has this product' }
  validate :product_belongs_to_deepest_category, on: :save

  def self.get_product_ids_by(sub_sub_category_ids_collection)
    return [] if !sub_sub_category_ids_collection.present?

    product_ids = unique_product_ids_by(category_id: sub_sub_category_ids_collection.first)

    sub_sub_category_ids_collection[1..-1].each do |sub_sub_categories_ids|
      product_ids = unique_product_ids_by(category_id: sub_sub_categories_ids, product_id: product_ids)
    end

    product_ids
  end

  def self.unique_product_ids_by(query_hash)
    where(query_hash).pluck(:product_id).uniq
  end

  def self.distinct_category_ids
    distinct.pluck(:category_id)
  end

  def product_belongs_to_deepest_category
    errors.add(:base, 'Product must belong to the deepest category') if category.depth != Category::MAX_DEPTH
  end
end
