class Product < ApplicationRecord
  has_many :products_categories, dependent: :destroy
  has_many :categories, through: :products_categories
end
