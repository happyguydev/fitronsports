class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]
  respond_to :json, :xml

  def index
    @products = if params[:search]
      Product.where('lower(title) ILIKE lower(?)', "%#{params[:search]}%")
    else
      Product.all
    end

    respond_with @products
  end

  def show
    respond_with @product
  end

  private

  def set_product
    @product = Product.find params[:id]
  end
end
