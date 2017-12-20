class Product < ApplicationRecord
  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories

  validates :name, presence: true
  validates :price_in_sgd, numericality: { greater_than: 0 }

  def self.filter_by_query(query)
    query.present? ? where('name ILIKE ?', "%#{query}%") : all
  end

  def self.filter_by_category(category, query = nil)
    product_ids = ProductsCategory.unique_product_ids_by(category_id: category.leaves.map(&:id))

    filter_by_product_ids(product_ids, query)
  end

  def self.filter_by_sub_sub_category_ids(sub_sub_category_ids, query = nil)
    product_ids = ProductsCategory.get_product_ids_by(sub_sub_category_ids)

    filter_by_product_ids(product_ids, query)
  end

  def self.filter_by_product_ids(product_ids, query = nil)
    return none if product_ids.blank?

    where(id: product_ids).filter_by_query(query)
  end

  private_class_method :filter_by_product_ids
end
