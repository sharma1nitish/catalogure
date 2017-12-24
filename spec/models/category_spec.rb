require 'rails_helper'

RSpec.describe Category, type: :model do
  before(:all) do
    @root_category = Category.create(name: 'Books')
    @sub_category = @root_category.children.create(name: 'Authors')
    @sub_sub_category = @sub_category.children.create(name: 'Stephen King')
  end

  def create_category_tree(root_category_name = nil, sub_category_name = nil, sub_sub_category_name = nil)
    root_category = Category.create(name: root_category_name || 'Clothing')
    sub_category = root_category.children.create(name: sub_category_name || 'Material')
    sub_sub_category = sub_category.children.create(name: sub_sub_category_name || 'Cotton')

    { root_category: root_category, sub_category: sub_category, sub_sub_category: sub_sub_category }
  end

  describe 'Category.create' do

    it 'should have a name' do
      expect(@root_category.name).to eq 'Books'
      expect(@sub_category.name).to eq 'Authors'
      expect(@sub_sub_category.name).to eq 'Stephen King'
    end

    it 'should not exceed max depth' do
      category = @sub_sub_category.children.create(name: 'Invalid')
      category.valid?
      expect(category.errors[:base]).to include('Sub Sub Category cannot have children')
    end

    it 'should be valid' do
      expect(@root_category).to be_valid
      expect(@sub_category).to be_valid
      expect(@sub_sub_category).to be_valid
    end

    it 'should not be valid if name is blank' do
      nameless_category = Category.create(name: '')

      expect(nameless_category.name).to be_blank
      expect(nameless_category).to_not be_valid
    end
  end

  describe 'Category.active_roots' do

    it 'should return an empty array if no products exist' do
      expect(Category.active_roots).to be_blank
    end

    it 'should return all top level categories for existing products' do
      categories = create_category_tree

      Product.create!(categories: [@sub_sub_category], name: 'The Shining', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
      Product.create!(categories: [categories[:sub_sub_category]], name: 'T Shirt', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

      expect(Category.active_roots).to eq [@root_category, categories[:root_category]]
    end
  end

  describe 'Category.get_self_and_ancestors_by' do
    before(:all) do
      @categories = create_category_tree
    end

    it 'should return self as an array if it is a root category' do
      expect(Category.get_self_and_ancestors_by([@root_category])).to eq [@root_category]
    end

    it 'should return an array of self and root_categories for an array of sub categories' do
      self_and_ancestors = Category.get_self_and_ancestors_by([@sub_category, @categories[:sub_category]])
      expected_categories = [@root_category, @sub_category].concat([@categories[:root_category], @categories[:sub_category]])

      expect(self_and_ancestors).to eq expected_categories
    end

    it 'should return an array of self and ancestors for an array of sub sub categories' do
      self_and_ancestors = Category.get_self_and_ancestors_by([@sub_sub_category, @categories[:sub_sub_category]])
      expected_categories = [@root_category, @sub_category, @sub_sub_category].concat(@categories.values)

      expect(self_and_ancestors).to eq expected_categories
    end
  end

  describe 'Category.ordered_subtree' do
    it 'should return a heirarchically ordered array of the subtree to which the category belongs' do
      expect(Category.ordered_subtree(@root_category)).to eq [@root_category, @sub_category, @sub_sub_category]
      expect(Category.ordered_subtree(@sub_category)).to eq [@root_category, @sub_category, @sub_sub_category]
      expect(Category.ordered_subtree(@sub_sub_category)).to eq [@root_category, @sub_category, @sub_sub_category]
    end
  end

  describe 'Category#active_descendants_tree' do

    it 'should return a empty hash if category is not root' do
      expect(@sub_category.active_descendants_tree).to be_blank
      expect(@sub_sub_category.active_descendants_tree).to be_blank
    end

    it 'should return a empty hash if descendant(s) of the root category do not have an existing product' do
      expect(@root_category.active_descendants_tree).to be_blank
    end

    it 'should return a tree of categories as a nested hash for a root category, descendant(s) of whose have an existing product' do
      Product.create!(categories: [@sub_sub_category], name: 'The Shining', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

      expect(@root_category.active_descendants_tree).to eq({ @sub_category => { @sub_sub_category => {}}})
    end
  end

  describe 'Category#leaves' do

    it 'should return self for a given sub sub category' do
      expect(@sub_sub_category.leaves).to eq [@sub_sub_category]
    end

    it 'should return all sub sub categories for a given parent category' do
      categories = create_category_tree

      expect(@root_category.leaves).to eq [@sub_sub_category]
      expect(categories[:root_category].leaves).to eq [categories[:sub_sub_category]]
    end
  end
end
