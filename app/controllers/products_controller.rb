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
    if @product.save
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
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Produktet blev opdateret"
      redirect_to product_path(@product)
    else
      flash[:error] = "Produktet blev ikke opdateret"
      render :edit
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def destroy
    @product = Product.find(params[:id])
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
      params.require(:product).permit(:name, :description, :price, :brand, :category)
    end
end
