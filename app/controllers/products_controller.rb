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
    # render plain: params[:product].inspect
    @product = Product.new(product_params)
    @product.user = current_user

    if @product.save && CategoriesProduct.create(product_id: @product.id, category_id: params[:category])
      flash[:success] = "Produktet er tilføjet"
      redirect_to @product
    else
      if @product.errors.any?
        flash.now[:error] = "Produktet blev ikke oprettet"
        render :new
      end
    end
  end

  def edit
    # render plain: isAdmin.inspect
  end

  def update
    @product.user = current_user
    if @product.update(product_params)
      flash[:success] = "Produktet blev opdateret"
      redirect_to product_path(@product)
    else
      flash[:error] = "Produktet blev ikke opdateret"
      render :edit
    end
  end

  def show
    categories = CategoriesProduct.where(product_id: params[:id])
    render plain: categories[0].product_id.inspect
    @categoryNames = []
    categories.each do |cat|
      @categoryNames[] = Category.find(id: cat.category_id)
    end
    render plain: @categoryNames.inspect
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
      params.require(:product).permit(:user_id, :brand_id, :name, :description, :price, :brand, :qty)
    end

    def set_product 
      @product = Product.find(params[:id])
    end

end
