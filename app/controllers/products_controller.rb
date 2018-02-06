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
        flash[:error] = "Produktet blev ikke oprettet"
        # flash[:error] = #{@product}"Produktet blev ikke oprettet"
        # @product.errors.full_messages.each do |msg|
        #   render plain: msg
        # end
        # render plain: @messages.inspect
        render :new
      end
    end
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
    params.require(:products).permit(:name, :description, :price, :brand, :category)
  end
end
