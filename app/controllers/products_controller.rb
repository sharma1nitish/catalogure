class ProductsController < ApplicationController
  before_action :set_category

  def index
    if params[:category_id].blank?
      @categories = Category.active_roots
      @products = Product.filter_by_query(params[:query]).order(:name)
    else
      return if !@category.root? # TODO: throw error

      @arranged_category_tree = @category.descendants_tree
      @products = Product.filter_by_category(@category, params[:query]).order(:name)
    end
  end

  def filter
    if params[:sub_sub_category_ids].present?
      products = Product.filter_by_sub_sub_category_ids(params[:sub_sub_category_ids], params[:query])
    else
      products = Product.filter_by_category(@category, params[:query])
    end

    render json: { products: helpers.attributes_of(products.order(:name)), status: :ok }
  end

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id].present?
  end
end
