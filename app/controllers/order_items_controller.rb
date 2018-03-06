class OrderItemsController < ApplicationController
  def index
    @product = Product.new
    @items = current_cart.order.items
    @order = current_cart.order
  end

  def create
    if params[:qty].to_i > 1
      current_cart.add_item(
        product_id: params[:product_id],
        qty: params[:qty],
      )
    end

    redirect_back fallback_location: products_path
  end


  def destroy
    current_cart.remove_item(id: params[:id])
    redirect_to cart_path
  end


  private
    def order_items_params
      params.require(:order_items).permit(:product_id, :price, :qty)
    end
end
