class ProductsController < ApplicationController
  def index
    if params[:category_id].blank?
      @categories = Category.active_roots
      @products = Product.filter_by_query(params[:query]).order(:name)
    else
      category = Category.find(params[:category_id])

      return if !category.root? # TODO: throw error

      @arranged_category_tree = category.descendants_tree
      @products = Product.filter_by_category_id(params[:category_id]).filter_by_query(params[:query]).order(:name)
    end
  end

  def filter
    if params[:sub_sub_category_ids].present?
      products = Product.filter_by_sub_sub_category_ids(params[:sub_sub_category_ids])
    elsif params[:category_id].present?
      products = Product.filter_by_category_id(params[:category_id])
    else
      products = Product
    end

    render json: { products: helpers.attributes_of(products.filter_by_query(params[:query]).order(:name)), status: :ok }
  end
end
