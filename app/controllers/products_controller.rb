class ProductsController < ApplicationController
  def index
    if params[:category_id].blank?
      @categories = Category.active_roots
      @products = Product.filter_by(params[:query])
    else
      category = Category.find(params[:category_id])

      return if !category.root? # TODO: throw error

      @arranged_category_tree = category.descendants_tree
      @products = Product.filter_by(params[:query], category.leaves.map(&:id))
    end
  end

  def filter
    render json: { products: Product.filter_by(params[:query], params[:category_ids]).order(:name), status: :ok }
  end
end
