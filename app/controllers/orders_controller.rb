class OrdersController < ApplicationController

  def new
    @order = current_cart.order
  end

  def create
    @order = current_cart.order

    if @order.update_attributes(
        status: "open",
        user_id: current_user.id
    )
      session[:cart_token] = nil
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.last
  end

end
