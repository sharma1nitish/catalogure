class ProductsController < ApplicationController
  before_action :set_page
  before_action :set_products

  def index
    if params[:category_id].blank?
      @categories = Category.active_roots
    else
      @category = Category.find(params[:category_id])

      @arranged_category_tree = @category.active_descendants_tree
      @products = @products.filter_by_category_id(params[:category_id])
    end

    @products = @products.filter_by_query(params[:query]).order(:name).page(@page)
    @total_pages = @products.total_pages
  end

  def filter
    if params[:sub_sub_category_ids].present?
      @products = @products.filter_by_sub_sub_category_ids(params[:sub_sub_category_ids].values)
    elsif params[:category_id].present?
      @products = @products.filter_by_category_id(params[:category_id])
    end

    @products = @products.filter_by_query(params[:query]).order(:name).page(@page)

    render json: { products: helpers.attributes_of(@products), current_page: @page, total_pages: @products.total_pages, status: :ok }
  end

  private

  def set_page
    @page = params[:page] || 1
  end

  def set_products
    @products = Product
  end
end
