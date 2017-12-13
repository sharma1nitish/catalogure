class AddAncestryToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
    # add_column :categories, :parent_category_id, :integer, index: true
    # add_foreign_key :categories, :categories, column: :parent_category_id
  end
end
