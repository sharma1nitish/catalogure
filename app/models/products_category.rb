class ProductsCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  validates :category_id, presence: true, uniqueness: { scope: :product_id, message: 'already has this product' }
end
