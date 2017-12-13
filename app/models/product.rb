class Product < ApplicationRecord
  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories

  validates :name, presence: true
  validates :price_in_sgd, numericality: { greater_than: 0 }

  def self.with_name_like(name, product_ids = [])
    if product_ids.present?
      products = where('id IN (:ids) AND name ILIKE :name', ids: product_ids, name: "%#{name}%")
    else
      products = where('name ILIKE :name', name: "%#{name}%")
    end

    products
  end
end
