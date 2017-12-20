class Product < ApplicationRecord
  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories

  validates :name, presence: true
  validates :price_in_sgd, numericality: { greater_than: 0 }

  def self.filter_by(query, category_ids = [])
    return all if query.blank? && category_ids.blank?

    products = self

    if category_ids.present?
      product_ids = ProductsCategory.get_product_ids_by(category_ids)

      return none if product_ids.blank?

      products = where(id: product_ids)
    end

    products = products.where('name ILIKE ?', "%#{query}%") if query.present?

    products
  end
end
