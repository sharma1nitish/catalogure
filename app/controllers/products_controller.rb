class ProductsController < ApplicationController
  before_action :set_page

  def index
    if params[:category_id].blank?
      @categories = Category.active_roots
      products = Product
    else
      category = Category.find(params[:category_id])

      redirect_to root_path && return if !category.root?

      @arranged_category_tree = category.active_descendants_tree
      products = Product.filter_by_category_id(params[:category_id])
    end

    @products = products.filter_by_query(params[:query]).order(:name).page(@page)
    @total_pages = @products.total_pages
  end

  def filter
    if params[:sub_sub_category_ids].present?
      products = Product.filter_by_sub_sub_category_ids(params[:sub_sub_category_ids])
    elsif params[:category_id].present?
      products = Product.filter_by_category_id(params[:category_id])
    else
      products = Product
    end

    products = products.filter_by_query(params[:query]).order(:name).page(@page)

    render json: { products: helpers.attributes_of(products), current_page: @page, total_pages: products.total_pages, status: :ok }
  end

  private

  def set_page
    @page = params[:page] || 1
  end
end
