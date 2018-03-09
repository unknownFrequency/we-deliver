class OrdersController < ApplicationController
  NEARBY_DELIVERY_FEE = BigDecimal.new("50.00")
  FAROUT_DELIVERY_FEE = BigDecimal.new("100.00")

  def calculateDeliveryFee
    zip =  current_user.zip.nil? ? "" : current_user.zip
    nearby_zips = (8000..8500).to_a.push(8520)
    nearby_zips.include?(zip) ? NEARBY_DELIVERY_FEE : FAROUT_DELIVERY_FEE
  end

  def new
    @order = current_cart.order
    if user_signed_in?
      @address = current_user.address.nil? ? "" : current_user.address
      @zip =  current_user.zip.nil? ? "" : current_user.zip
    end
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

      redirect_to order_path @order 
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @delivery_fee = calculateDeliveryFee
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
