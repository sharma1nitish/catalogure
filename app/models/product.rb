class Product < ApplicationRecord
  paginates_per 20

  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories

  validates :name, presence: true
  validates :description, presence: true
  validates :price_in_sgd, numericality: { greater_than: 0 }

  def self.filter_by_query(query)
    query.present? ? where('name ILIKE ?', "%#{query}%") : all
  end

  def self.filter_by_category_id(category_id)
    category = Category.find(category_id)
    product_ids = ProductsCategory.unique_product_ids_by(category_id: category.leaves.map(&:id))

    filter_by_product_ids(product_ids)
  end

  def self.filter_by_sub_sub_category_ids(sub_sub_category_ids)
    product_ids = ProductsCategory.get_product_ids_by(sub_sub_category_ids)

    filter_by_product_ids(product_ids)
  end

  def self.filter_by_product_ids(product_ids)
    return none if product_ids.blank?

    where(id: product_ids)
  end

  private_class_method :filter_by_product_ids
end
