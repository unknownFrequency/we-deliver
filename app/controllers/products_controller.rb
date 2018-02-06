class ProductsController < ApplicationController
  def index
    @products = Product.all 
  end

  def new
    @product = Product.new
  end

  def create
    # render plain: params[:product].inspect
    @product = Product.new(product_params)
    @product.save
    flash[:success] = "Produktet er tilføjet"
    redirect_to @product
  end

  def edit
  end

  def update
  end

  def show
    @product = Product.find(params[:id])
  end

  private
  def product_params
    params.require(:products).permit(:name, :description, :price, :brand)
  end
end
