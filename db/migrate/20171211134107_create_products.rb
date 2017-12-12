class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price_in_sgd, precision: 19, scale: 4

      t.timestamps
    end
  end
end
