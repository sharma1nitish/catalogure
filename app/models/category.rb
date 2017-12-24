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

  def self.get_self_and_ancestors_by(categories)
    where(id: categories.map(&:path_ids).flatten.uniq)
  end

  def self.ordered_subtree(category)
    arranged_subtree = category.is_a?(Category) ? category.root.subtree.arrange : category
    arranged_subtree.each_with_object([]) do |(key,value), keys|
      keys << key
      keys.concat(ordered_subtree(value)) # value is not a category object after first recursion
    end
  end

  def self.all_ordered_subtrees
    roots.map do |root_category|
      ordered_subtree(root_category)
    end.flatten
  end

  def active_descendants_tree # To get categories which have products
    return {} if !root?

    categories_hash = subtree.arrange.values.first.map do |sub_category, sub_sub_categories_hash|
      sub_sub_categories_hash.select! { |category, value| category.products_categories.present? }

      [sub_category, sub_sub_categories_hash] if sub_sub_categories_hash.present?
    end

    Hash[categories_hash.compact]
  end

  def leaves
    subtree.select(&:childless?)
  end

  def depth_less_than_max_depth
    errors.add(:base, 'Sub Sub Category cannot have children') if has_parent? && !(parent.depth < MAX_DEPTH)
  end
end
