class Product < ApplicationRecord
  ransacker :categories,
    formatter: proc { |category_id|
      category = Category.find(category_id)
      category_ids = category.childless? ? [category_id] : category.leaves.pluck(:id)
      ProductsCategory.unique_product_ids_by(category_id: category_ids).presence
    } do |parent|
    parent.table[:id]
  end

  paginates_per 20

  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories

  before_validation :sanitize_category_ids

  validates :category_ids, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price_in_sgd, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  def self.filter_by_query(query)
    query.present? ? where('name ILIKE ?', "%#{query}%") : all
  end

  def self.filter_by_category_id(category_id)
    category = Category.find(category_id)
    product_ids = ProductsCategory.unique_product_ids_by(category_id: category.leaves.map(&:id))

    filter_by_ids(product_ids)
  end

  def self.filter_by_sub_sub_category_ids(sub_sub_category_ids)
    product_ids = ProductsCategory.get_product_ids_by(sub_sub_category_ids)

    filter_by_ids(product_ids)
  end

  def self.filter_by_ids(product_ids)
    return none if product_ids.blank?

    where(id: product_ids)
  end

  def sanitize_category_ids
    self.category_ids = Category.where(id: self.category_ids).select(&:childless?).pluck(:id)
  end

  private_class_method :filter_by_ids
end
