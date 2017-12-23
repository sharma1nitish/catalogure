require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with valid attributes' do
    category = Category.create(name: 'category')
    sub_category = category.children.create(name: 'sub_category')
    sub_sub_category = sub_category.children.create(name: 'sub_sub_category')

    invalid_child_category = sub_sub_category.children.create(name: 'invalid_category')
    nameless_category = Category.create(name: '')

    expect(nameless_category).to_not be_valid
    expect(invalid_child_category).to_not be_valid

    expect(category).to be_valid
    expect(sub_category).to be_valid
    expect(sub_sub_category).to be_valid
  end

  it 'returns array of root categories for products belonging sub sub categories' do
    active_roots = []

    1.upto(4) do |i|
      category = Category.create(name: "category #{i}")
      sub_category = category.children.create(name: "sub_category #{i}.#{i}")
      sub_sub_category = sub_category.children.create(name: "sub_sub_category #{i}.#{i}.#{i}")

      if i.even?
        Product.create!(categories: [sub_sub_category], name: "product #{i}.#{i}.#{i}", description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
        active_roots << category
      end
    end

    expect(Category.active_roots).to eq active_roots
  end

  it 'returns an array of self and ancestors for an array of categories' do
    root_categories = []
    sub_categories = []
    leaf_categories = []

    1.upto(2) do |i|
      category = Category.create(name: "category #{i}")
      sub_category = category.children.create(name: "sub_category #{i}.#{i}")
      leaf_categories << sub_category.children.create(name: "sub_sub_category #{i}.#{i}.#{i}")
      sub_categories << sub_category
      root_categories << category
    end

    expect(Category.get_self_and_ancestors_by(leaf_categories)).to eq Category.all.to_a
    expect(Category.get_self_and_ancestors_by(sub_categories)).to eq [root_categories, sub_categories].transpose.flatten
    expect(Category.get_self_and_ancestors_by(root_categories)).to eq root_categories
  end

  it 'returns an heirarchically ordered array of the subtree to which the category belongs' do
    category = Category.create(name: "category")
    sub_category = category.children.create(name: "sub_category")
    sub_sub_category = sub_category.children.create(name: "sub_sub_category")
    ordered_subtree = [category, sub_category, sub_sub_category]

    ordered_subtree.each do |category|
      expect(Category.ordered_subtree(category)).to eq ordered_subtree
    end
  end

  it 'returns a tree of active descendant categories as a nested hash for a given category' do
    root_categories = []

    1.upto(2) do |i|
      category = Category.create(name: "category #{i}")
      sub_category = category.children.create(name: "sub_category #{i}.#{i}")
      sub_sub_category = sub_category.children.create(name: "sub_sub_category #{i}.#{i}.#{i}")

      root_categories << category

      if i.even?
        Product.create(categories: [sub_sub_category], name: "product #{i}.#{i}.#{i}", description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))
      end
    end

    last_root_category = root_categories.last

    expect(root_categories.first.active_descendants_tree).to eq({})
    expect(last_root_category.active_descendants_tree).to eq({ last_root_category.children.first => { last_root_category.leaves.first => {}}})
  end

  it 'returns an array of deepest categories in the heirarchy for a given category' do
    leaves = []

    category = Category.create(name: "category")
    sub_category = category.children.create(name: "sub_category")

    1.upto(2) do |i|
      leaves << sub_category.children.create(name: "sub_sub_category #{i}")
    end

    expect(category.leaves).to eq leaves
    expect(sub_category.leaves).to eq leaves
    leaves.each { |leaf_category| expect(leaf_category.leaves).to eq [leaf_category] }
  end
end
