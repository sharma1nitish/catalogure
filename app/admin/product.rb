ActiveAdmin.register Product do
  filter :categories_in, as: :select, collection: Category.all
  filter :name, as: :string
  filter :price_in_sgd
end
