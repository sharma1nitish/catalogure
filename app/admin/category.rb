ActiveAdmin.register Category do
  permit_params :name, parent_category_attributes: [:id, :_destroy, :name], sub_categories_attributes: [:id, :_destroy, :name]

  filter :name, as: :string

  show do
    attributes_table do
      row :id
      row :name
      row(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
    end

    panel 'Category Tree' do
      root_category = category.root? ? category : category.root

      table_for root_category.subtree do |category|
        column :id
        column(:name) { |category| link_to category.name, admin_category_path(category) }
        column(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
      end
    end
  end

  form do |f|
    if params[:action] == "edit"
      f.inputs 'Category Form Details' do
        f.input :name
      end
    else
      f.inputs 'Parent Category', for: [:parent_category, f.object.parent || Category.new] do |ff|
        ff.input :name
      end

      f.inputs 'Category Form Details' do
        f.input :name

        f.has_many :sub_categories do |ff|
          ff.input :name
        end
      end
    end

    f.actions
  end

  controller do
    def create
      category_params = params.require(:category).permit(:name, parent_category_attributes: [:id, :name], sub_categories_attributes: [:id, :name])

      parent_params = category_params.delete(:parent_category_attributes)
      children_params = category_params.delete(:sub_categories_attributes).values

      parent = Category.create!(parent_params)

      if parent.persisted?
        category = parent.children.create!(category_params)
        category.children.create!(children_params) if category.persisted?
      end

      redirect_to admin_categories_path
    end

    def destroy
      Category.find(params[:id]).subtree.destroy_all

      redirect_to admin_categories_path
    end
  end
end
