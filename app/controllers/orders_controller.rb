class OrdersController < ApplicationController

  def new
    @order = current_cart.order
    if user_signed_in?
      @address = current_user.address.nil? ? "" : current_user.address
      @zip =  current_user.zip.nil? ? "" : current_user.zip
    end

    # render plain: current_user.inspect
  end

  def create
    @order = current_cart.order
    # render plain: current_user.inspect
    unless params[:email].nil? && current_user.email.nil?
      current_user.email = params[:email]
    end
    unless params[:name].nil? && current_user.name.nil?
      current_user.name = params[:name]
    end
    unless current_user.save(current_user)
      Rails.logger.info("** ---- User did not get updates from order#create ---- **")
      Rails.logger.info(current_user.inspect)
    end

    if @order.update_attributes(order_params)
      session[:cart_token] = nil
      updateProductQty @order
      # render plain: @order.inspect

      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def updateProductQty(order)
    order.items.each do |order_item|
      product = Product.find(order_item.product_id)
      product.qty -= order_item.qty
      product.save!
    end
  end

  def complete_order 
    order = Order.find(params[:id])
    order.status = "complete"
    order.save!
    redirect_to order_path(order)
  end

  private

  def order_params
    params.require(:order)
      .permit(:delivery_address, :zip, :total, :status, :payment_type) 
  end
end
