ActiveAdmin.register Category do
  permit_params :name, parent_category_attributes: [:id, :_destroy, :name], sub_categories_attributes: [:id, :_destroy, :name]

  filter :name, as: :string

  index do
    selectable_column
    column :id
    column(:name) { |category| link_to category.name, admin_category_path(category) }
    column(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
    end

    panel 'Category Tree' do
      root_category = category.root? ? category : category.root

      table_for Category.ordered_subtree(root_category) do |category|
        column :id
        column(:name) { |category| link_to category.name, admin_category_path(category) }
        column(:ancestry) { |category| category.ancestry.presence || 'Root Category' }
      end
    end
  end

  form do |f|
    if f.object.new_record? || !f.object.is_root?
      f.inputs 'Parent Category', for: [:parent_category, f.object.parent || Category.new] do |ff|
        ff.input :name, input_html: { disabled: params[:action] == "edit" }
      end
    end

    f.inputs 'Category Form Details' do
      f.input :name

      if f.object.new_record? || f.object.depth < Category::MAX_DEPTH
        f.has_many :sub_categories do |ff|
          ff.input :name
        end
      end
    end

    f.actions
  end

  controller do
    before_action :set_category_and_children_params, only: [:create, :update]
    before_action :set_category, only: [:update, :destroy]

    def create
      parent = Category.create(@category_params.delete(:parent_category_attributes))

      if parent.persisted?
        category = parent.children.create(@category_params)
        category.children.create(@children_params) if category.persisted? && @children_params.present?
      end

      redirect_to admin_categories_path
    end

    def update
      @category.update_attributes(@category_params)

      if @children_params.present?
        @children_params.each do |children_params|
          if children_params[:id].present?
            Category.find(children_params[:id]).update_attributes(children_params)
          else
            @category.children.create(children_params)
          end
        end
      end

      redirect_to admin_category_path
    end

    def destroy
      @category.subtree.destroy_all

      redirect_to admin_categories_path
    end

    private

    def set_category_and_children_params
      @category_params = params.require(:category).permit(:name, sub_categories_attributes: [:id, :name])
      @children_params = @category_params.delete(:sub_categories_attributes).try(:values)
    end

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
