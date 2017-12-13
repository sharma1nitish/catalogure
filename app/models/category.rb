class Category < ApplicationRecord
  MAX_DEPTH = 2

  has_ancestry

  has_many :products_categories, dependent: :destroy
  has_many :products, through: :products_categories
  has_one :parent_category, class_name: 'Category', primary_key: :ancestry, foreign_key: :id
  has_many :sub_categories, class_name: 'Category', foreign_key: :ancestry, dependent: :destroy

  accepts_nested_attributes_for :parent_category
  accepts_nested_attributes_for :sub_categories

  validates :name, presence: true
  validate :depth_less_than_max_depth

  def depth_less_than_max_depth
    errors.add(:base, 'Sub Sub Category cannot have children.') if has_parent? && !(parent.depth < MAX_DEPTH)
  end

  def self.active(limit = 50)
    categories = where(id: ProductsCategory.distinct.pluck(:category_id))
    ancestor_categories = where(id: categories.map(&:ancestor_ids).flatten.uniq)
    # ancestor_categories.or(categories).order(:name).limit(limit) # Even with lazy loading this triggers one extra select query
    (ancestor_categories + categories).sort_by(&:name)[0...limit]
  end

  def self.deepest_categories_by_ids(ids)
    return [] if ids.blank?

    if ids.length > 1
      active.select do |category|
        ids.include?(category.id) && (ids & category.descendant_ids).blank?
      end
    else
      [active.find { |category| category.id == ids.first }]
    end
  end
end
