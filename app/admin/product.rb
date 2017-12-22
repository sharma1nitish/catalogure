ActiveAdmin.register Product do
  filter :categories_in, as: :select, collection: Category.all
  filter :name, as: :string
  filter :price_in_sgd

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price_in_sgd

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price_in_sgd
    end

    panel 'Categories' do
      table_for Category.get_self_and_ancestors_by(product.categories) do |category|
        column :id
        column(:name) { |category| link_to category.name, admin_category_path }
        column(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
      end
    end
  end

  form do |f|
    f.inputs 'Product Form Details' do
      f.input :category_ids, as: :select2_multiple, collection: Category.all_ordered_subtrees.pluck(:name, :id)
      f.input :name
      f.input :description
      f.input :price_in_sgd
    end

    f.actions
  end

  controller do
    before_action :set_product_params, only: [:create, :update]

    def create
      product = Product.create(@product_params)
      redirect_to admin_product_path(product)
    end

    def update
      product = Product.find(params[:id])
      product.update_attributes(@product_params)

      redirect_to admin_product_path(product)
    end

    private

    def set_product_params
      category_ids = params[:product][:category_ids].reject(&:blank?)
      @product_params = params.require(:product).permit(:name, :description, :price_in_sgd).merge!(category_ids: category_ids)
    end
  end
end
