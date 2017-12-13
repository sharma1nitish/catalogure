class ProductsController < ApplicationController
  def filter
    query = params[:query]

    if sanitized_category_ids.blank?
      products = query.present? ? Product.with_name_like(query) : Product
    else
      product_ids = ProductsCategory.where(category_id: sanitized_category_ids).pluck(:product_id).uniq
      products = query.present? ? Product.with_name_like(query, product_ids) : Product.where(id: product_ids)
    end

    render json: { products: products.order(:name), status: :ok }
  end

  private

  def sanitized_category_ids # Select only the deepest categories in the heirarchy and their descendants for specificity
    return [] if params[:ids].blank?

    deepest_categories = Category.deepest_categories_by_ids(params[:ids].map(&:to_i).uniq)

    deepest_category_ids = deepest_categories.pluck(:id)
    deepest_categories_descendants_ids = deepest_categories.map(&:descendant_ids).flatten

    deepest_category_ids.concat(deepest_categories_descendants_ids) if deepest_categories_descendants_ids.present?

    deepest_category_ids
  end
end
