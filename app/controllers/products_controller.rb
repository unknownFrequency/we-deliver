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
    elsif @product.errors.any?
      flash.now[:error] = "Produktet blev ikke oprettet"
    end

    redirect_to products_path
  end

  def edit
    # render plain: isAdmin.inspect
  end

  def update
    @product.user = current_user
    if @product.update(product_params)
      category = Category.find(params[:category_id]) 
      @product.categories << category
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

    # render plain: Category.find(categories[0].category_id).inspect
    # render plain: @categoryNames.inspect
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
     # redirect_to products_path
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
