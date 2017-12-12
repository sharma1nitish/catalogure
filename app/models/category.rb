class Category < ApplicationRecord
  MAX_DEPTH = 2

  has_ancestry

  scope :active, -> (limit = 50) { where(id: ProductsCategory.pluck(:category_id).uniq).order(:name).limit(limit) }

  has_many :products_categories, dependent: :destroy
  has_many :products, through: :products_categories

  validates :name, presence: true
  validate :depth_less_than_max_depth

  def depth_less_than_max_depth
    errors.add(:base, 'Sub-Sub-Category cannot have children.') if has_parent? && !(parent.depth < MAX_DEPTH)
  end
end
