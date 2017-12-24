require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:all) do
    @root_category = Category.create(name: 'Books')

    @sub_category1 = @root_category.children.create(name: 'Authors')
    @sub_sub_category1 = @sub_category1.children.create(name: 'Stephen King')
    @sub_sub_category2 = @sub_category1.children.create(name: 'J. K. Rowling')

    @sub_category2 = @root_category.children.create(name: 'Genre')
    @sub_sub_category3 = @sub_category2.children.create(name: 'Fantasy')

    categories = [@root_category, @sub_category1, @sub_sub_category1]

    @product1 = Product.create(
      categories: categories,
      name: 'The Shining',
      description: 'A horror fiction',
      price_in_sgd: 1
    )

    @product2 = Product.create(
      categories: categories,
      name: 'The Mist',
      description: 'A horror fiction',
      price_in_sgd: 1
    )

    @product3 = Product.create(
      categories: [@sub_sub_category2, @sub_sub_category3],
      name: 'Harry Potter and the Prisoner of Azkaban',
      description: 'A HP book',
      price_in_sgd: 1
    )
  end

  describe 'Product.create' do

    it 'should belong to atleast 1 sub sub category' do
      expect(@product1.categories).to eq [@sub_sub_category1]
    end

    it 'should have a name' do
      expect(@product1.name).to eq 'The Shining'
    end

    it 'should have a description' do
      expect(@product1.description).to eq 'A horror fiction'
    end

    it 'should have a price' do
      expect(@product1.price_in_sgd).to eq 1
    end

    it 'should be valid' do
      expect(@product1).to be_valid
    end

    it 'should not be valid if categories does not contain a sub sub category' do
      product = Product.new(
        name: 'The Shining',
        description: 'A horror fiction',
        price_in_sgd: 1
      )

      product.categories = [@root_category, @sub_category1]
      product.save
      expect(product).to_not be_valid

      product.categories = [@root_category]
      product.save
      expect(product).to_not be_valid

      product.categories = [@sub_category1]
      product.save
      expect(product).to_not be_valid
    end

    it 'should not be valid if name is blank' do
      product = Product.create(
        categories: [@root_category, @sub_category1, @sub_sub_category1],
        name: '',
        description: 'A horror fiction',
        price_in_sgd: 1
      )

      expect(product.name).to be_blank
      expect(product).to_not be_valid
    end

    it 'should not be valid if description is blank' do
      product = Product.create(
        categories: [@root_category, @sub_category1, @sub_sub_category1],
        name: 'The Shining',
        description: '',
        price_in_sgd: 1
      )

      expect(product.description).to be_blank
      expect(product).to_not be_valid
    end

    it 'should not be valid if price is invalid' do
      product = Product.create(
        categories: [@root_category, @sub_category1, @sub_sub_category1],
        name: 'The Shining',
        description: 'A horror fiction',
        price_in_sgd: 0
      )

      expect(product).to_not be_valid
    end
  end

  describe 'Product.filter_by_query' do

    it 'should return all products if query string is blank' do
      expect(Product.filter_by_query('')).to eq Product.all
    end

    it 'should return products with name containing the query string' do
      expect(Product.filter_by_query('The')).to eq [@product1, @product2, @product3]
      expect(Product.filter_by_query('Shining')).to eq [@product1]
      expect(Product.filter_by_query('Harry')).to eq [@product3]
    end
  end

  describe 'Product.filter_by_category_id' do

    it 'should return an empty array if category does not exist' do
      expect(Product.filter_by_category_id(nil)).to be_blank
    end

    it 'should return an empty array if given category or its descendants have no products' do
      root_category = Category.create(name: 'Clothing')
      sub_category = root_category.children.create(name: 'Material')
      sub_sub_category = sub_category.children.create(name: 'Cotton')

      expect(Product.filter_by_category_id(root_category.id)).to be_blank
      expect(Product.filter_by_category_id(sub_category.id)).to be_blank
      expect(Product.filter_by_category_id(sub_sub_category.id)).to be_blank
    end

    it 'should return products belonging a given category or its descendants' do
      expect(Product.filter_by_category_id(@root_category.id)).to eq [@product1, @product2, @product3]
      expect(Product.filter_by_category_id(@sub_category1.id)).to eq [@product1, @product2, @product3]
      expect(Product.filter_by_category_id(@sub_sub_category1.id)).to eq [@product1, @product2]
      expect(Product.filter_by_category_id(@sub_category2.id)).to eq [@product3]
    end
  end

  describe 'Product.filter_by_sub_sub_category_ids' do

    it 'should return products belonging a given collection of sub_sub_category_ids arrays belonging to a single parent' do
      expect(Product.filter_by_sub_sub_category_ids([[@sub_sub_category1.id, @sub_sub_category2.id], [@sub_sub_category3.id]])).to eq [@product3]
      expect(Product.filter_by_sub_sub_category_ids([[@sub_sub_category1.id, @sub_sub_category2.id]])).to eq [@product1, @product2, @product3]
    end
  end
end
