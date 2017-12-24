require 'rails_helper'

RSpec.describe ProductsCategory, type: :model do
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

  describe 'ProductsCategory.get_product_ids_by' do

    it 'should return an empty array if the given collection of sub_sub_category_ids arrays is blank' do
      expect(ProductsCategory.get_product_ids_by([])).to be_blank
    end

    it 'should return product_ids belonging a given collection of sub_sub_category_ids arrays belonging to a single parent' do
      expect(ProductsCategory.get_product_ids_by([[@sub_sub_category1.id, @sub_sub_category2.id], [@sub_sub_category3.id]])).to eq [@product3.id]
      expect(ProductsCategory.get_product_ids_by([[@sub_sub_category1.id, @sub_sub_category2.id]]).sort).to eq [@product1.id, @product2.id, @product3.id].sort
    end
  end

  describe 'ProductsCategory.unique_product_ids_by' do

    it 'should return an empty array if category_id is blank' do
      expect(ProductsCategory.unique_product_ids_by(category_id: nil)).to be_blank
      expect(ProductsCategory.unique_product_ids_by(category_id: [])).to be_blank
    end

    it 'should return an empty array if the category_id is not associated with the product_id' do
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category2.id, product_id: @product1.id)).to be_blank
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category3.id, product_id: @product2.id)).to be_blank
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category1.id, product_id: @product3.id)).to be_blank
    end

    it 'should return the product_ids associated with the category_id' do
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category1.id)).to eq [@product2.id, @product1.id]
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category2.id)).to eq [@product3.id]
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category3.id)).to eq [@product3.id]
    end

    it 'should return the product_id of the record if both category_id and product_id are present' do
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category1.id, product_id: @product1.id)).to eq [@product1.id]
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category1.id, product_id: @product2.id)).to eq [@product2.id]
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category2.id, product_id: @product3.id)).to eq [@product3.id]
      expect(ProductsCategory.unique_product_ids_by(category_id: @sub_sub_category3.id, product_id: @product3.id)).to eq [@product3.id]
    end
  end
end
