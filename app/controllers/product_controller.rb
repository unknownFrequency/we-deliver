class ProductController < ApplicationController
  def index
    
  end

  def new

  end

  def create
    # render plain: params[:product].inspect
    @product = Product.new(product_params)
    @product.save
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
    params.require(:product).permit(:name, :description, :price, :brand)
  end
end
