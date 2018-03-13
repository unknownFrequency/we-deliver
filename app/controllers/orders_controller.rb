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
      @zip = current_user.zip.nil? ? "" : current_user.zip
      @phone = current_user.phone.nil? ? "" : current_user.phone
    end
  end

  def create
    @order = current_cart.order

    # render plain: params

    if isAdmin?
      user = User.new()
      user.name = params[:name] unless params[:name].nil?
      user.email = params[:email] unless params[:email].nil?
      user.zip = params[:order][:zip]
      user.address = params[:order][:delivery_address]
      user.phone = params[:phone]
      user.password = user.password_confirmation = generate_password

      if user.save! 
        @order.user_id = user.id 
      else 
        redirect_back fallback_location: cart_path, flash: { notice: "Brugeren kunne ikke oprettes! Kontakt venligst admin" } 
        return false
      end
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
    @user = User.find(@order.user_id)
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
