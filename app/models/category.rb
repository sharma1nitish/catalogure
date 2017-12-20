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

  def self.active_roots
    distinct_category_ids = ProductsCategory.distinct.pluck(:category_id)
    root_ids = where(id: distinct_category_ids).map(&:root_id).uniq
    where(id: root_ids)
  end

  def descendants_tree
    subtree.arrange.values.first
  end

  def leaves
    subtree.select(&:is_childless?)
  end

  def depth_less_than_max_depth
    errors.add(:base, 'Sub Sub Category cannot have children.') if has_parent? && !(parent.depth < MAX_DEPTH)
  end
end
