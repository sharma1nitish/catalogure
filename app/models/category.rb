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
    root_ids = where(id: ProductsCategory.distinct_category_ids).map(&:root_id).uniq
    where(id: root_ids)
  end

  def self.get_self_and_ancestors_by(leaf_categories)
    where(id: leaf_categories.map(&:path_ids).flatten.uniq)
  end

  def active_descendants_tree
    categories_hash = subtree.arrange.values.first.map do |sub_category, sub_sub_categories_hash|
      sub_sub_categories_hash.select! { |category, value| category.products_categories.present? }
      [sub_category, sub_sub_categories_hash]
    end

    Hash[categories_hash]
  end

  def leaves
    subtree.select(&:childless?)
  end

  def depth_less_than_max_depth
    errors.add(:base, 'Sub Sub Category cannot have children.') if has_parent? && !(parent.depth < MAX_DEPTH)
  end
end
