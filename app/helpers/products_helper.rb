module ProductsHelper
  def attributes_of(products)
    products.map do |product|
      {
        name: product.name.capitalize,
        description: product.description.truncate(250),
        price_in_sgd: product.price_in_sgd.truncate(1).to_f
      }
    end
  end
end
