class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :isAdmin, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def index
    @products = Product.all 
  end

  def new
    @brands = Brand.all 
    @product = Product.new
  end

  def create
    # render plain: params.inspect
    @product = Product.new(product_params)
    @product.user = current_user
    if @product.save 
      params[:category_ids].each do |cat_id|
        @product.categories << Category.find(cat_id) 
      end
      flash[:success] = "Produktet er tilføjet"
      redirect_to product_path(@product)
    elsif @product.errors.any?
      flash[:error] = "Produktet blev ikke oprettet"
      render :edit
    end
  end

  def edit
    # render plain: isAdmin.inspect
  end

  def update
    cat_ids = []
    @product.user = current_user

    if @product.update(product_params)
      # Look for dublicates
      if CategoriesProduct.where(product_id: @product.id).any?
        categories_product = CategoriesProduct.where(product_id: @product.id)
        categories_product.each do |cat|
          cat_ids.push cat.category_id
        end
      end

      if params[:category_ids].kind_of?(Array)
        params[:category_ids].each do |cat_id|
          unless cat_ids.include?(cat_id.to_i)
            @product.categories << Category.find(cat_id)
          end 
        end 
      else
        unless cat_ids.include?(cat_id.to_i)
          @product.categories << Category.find(cat_id)
        end 
      end

      flash[:success] = "Produktet blev opdateret"
      redirect_to product_path(@product)
    else
      flash[:error] = "Produktet blev ikke opdateret"
      render :edit
    end
  end

  def show
    categories = CategoriesProduct.all.where(product_id: params[:id])

    @categoryNames = []
    categories.each do |cat|
      @categoryNames.push Category.find(cat.category_id)
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = "Produktet blev slettet"
      redirect_to products_path
    else
      flash[:error] = "Produktet blev ikke slettet"
      redirect_to product_path(@product)
    end
  end

  protected
    def resource_not_found
      flash[:error] = "Produktet kunne ikke findes" 
      redirect_to products_path
    end

  private
    def product_params
      params.require(:product)
        .permit(:user_id, :brand_id, :name, :description, :price, :qty, categories_products_attributes: [:product_id, :category_id]) 
    end

    def set_product 
      @product = Product.find(params[:id])
    end

end
