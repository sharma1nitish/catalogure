require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'is valid with valid attributes' do
    category = Category.create(name: 'category')
    sub_category = category.children.create(name: 'sub_category')
    sub_sub_category = sub_category.children.create(name: 'sub_sub_category')

    name = 'product'
    description = FFaker::Lorem.paragraph(sentence_count = 8)
    price = rand(1..100)

    product_without_categories = Product.create(categories: [], name: name, description: description, price_in_sgd: price)
    product_with_invalid_categories = Product.create(categories: [category, sub_category], name: name, description: description, price_in_sgd: price)
    nameless_product = Product.create(categories: [sub_sub_category], name: '', description: description, price_in_sgd: price)
    descriptionless_product = Product.create(categories: [sub_sub_category], name: name, description: '', price_in_sgd: price)
    product_with_invalid_price = Product.create(categories: [sub_sub_category], name: name, description: '', price_in_sgd: 0)

    valid_product = Product.create(categories: [sub_sub_category], name: name, description: description, price_in_sgd: price)

    expect(product_without_categories).to_not be_valid
    expect(product_with_invalid_categories).to_not be_valid
    expect(nameless_product).to_not be_valid
    expect(descriptionless_product).to_not be_valid
    expect(product_with_invalid_price).to_not be_valid

    expect(valid_product).to be_valid
  end

  it 'returns products with name containing query string' do
    category = Category.create(name: 'category')
    sub_category = category.children.create(name: 'sub_category')
    sub_sub_category = sub_category.children.create(name: 'sub_sub_category')

    description = FFaker::Lorem.paragraph(sentence_count = 8)
    price = rand(1..100)

    product_1 = Product.create(categories: [sub_sub_category], name: 'GTA San Andreas', description: description, price_in_sgd: price)
    product_2 = Product.create(categories: [sub_sub_category], name: 'GTA Vice City', description: description, price_in_sgd: price)
    product_3 = Product.create(categories: [sub_sub_category], name: 'Need for Speed', description: description, price_in_sgd: price)

    expect(Product.filter_by_query('GTA')).to eq [product_1, product_2]
  end

  it 'returns products belonging a given category' do
    category = Category.create(name: 'category')
    sub_categories = []
    sub_sub_categories = []

    1.upto(2) do |i|
      sub_category = category.children.create(name: "sub_category #{i}.#{i}")
      sub_categories << sub_category
      sub_sub_categories << sub_category.children.create(name: "sub_sub_category #{i}.#{i}.#{i}")
    end

    product = Product.create(categories: [sub_sub_categories.last], name: 'product', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

    expect(Product.filter_by_category_id(sub_categories.first.id)).to eq []
    expect(Product.filter_by_category_id(sub_sub_categories.first.id)).to eq []

    expect(Product.filter_by_category_id(category.id)).to eq [product]
    expect(Product.filter_by_category_id(sub_categories.last.id)).to eq [product]
    expect(Product.filter_by_category_id(sub_sub_categories.last.id)).to eq [product]
  end

  it 'returns products belonging a given leaf categories' do
    category = Category.create(name: 'category')
    sub_categories = []
    sub_sub_categories = []

    1.upto(2) do |i|
      sub_category = category.children.create(name: "sub_category #{i}.#{i}")
      sub_categories << sub_category
      sub_sub_categories << sub_category.children.create(name: "sub_sub_category #{i}.#{i}.#{i}")
    end

    product = Product.create(categories: [sub_sub_categories.last], name: 'product', description: FFaker::Lorem.paragraph(sentence_count = 8), price_in_sgd: rand(1..100))

    expect(Product.filter_by_sub_sub_category_ids(sub_categories.first.id)).to eq []
    expect(Product.filter_by_sub_sub_category_ids(sub_sub_categories.first.id)).to eq []

    expect(Product.filter_by_sub_sub_category_ids(category.id)).to eq [product]
    expect(Product.filter_by_sub_sub_category_ids(sub_categories.last.id)).to eq [product]
    expect(Product.filter_by_sub_sub_category_ids(sub_sub_categories.last.id)).to eq [product]
  end
end
