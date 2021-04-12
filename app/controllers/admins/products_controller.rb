module Admins
  class ProductsController < ApplicationController
    layout 'admins/dashboard'
    before_action :set_product, only: %i[destroy edit update show]
    before_action :authenticate_admin!, except: %i[show_public]
    before_action :clear_flash

    def index
      @products = Product.active
    end

    def destroy
      @product.deactivate
      redirect_to admins_products_path, notice: t("admin.products.flash.destroyed") 
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to admins_products_url, notice: t("admin.products.flash.created") 
      else
        flash.now[:error] = "#{t("admin.products.flash.errors.created")} #{@product.errors.full_messages}"
        render 'admins/products/new' 
      end
    end

    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to admins_products_url, notice: t("admin.products.flash.updated") }
        else
          flash.now[:error] = "#{t("admin.products.flash.errors.updated")} #{@product.errors.full_messages}"
          format.html { render "admins/products/edit" }
        end
      end
    end

    def show; end

    def edit; end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :price_cents, :price_currency, :isbn, :sku)
    end

    def clear_flash 
      flash.discard 
    end
  end
end
