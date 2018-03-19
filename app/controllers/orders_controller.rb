class OrdersController < ApplicationController
  NEARBY_DELIVERY_FEE = BigDecimal.new("50.00")
  FAROUT_DELIVERY_FEE = BigDecimal.new("100.00")

  

  def calculateDeliveryFee
    zip = user_signed_in? && current_user.zip.nil? ? "" : 8000 #todo
    nearby_zips = (8000..8500).to_a.push(8520)
    nearby_zips.include?(zip) ? NEARBY_DELIVERY_FEE : FAROUT_DELIVERY_FEE
  end

  def index
    @orders = Order.all
  end

  def new
    @order = current_cart.order
    if user_signed_in? && !isAdmin?
      @email = current_user.email.nil? ? "" : current_user.email
      @address = current_user.address.nil? ? "" : current_user.address
      @zip = current_user.zip.nil? ? "" : current_user.zip
      @phone = current_user.phone.nil? ? "" : current_user.phone
      @name = current_user.name.nil? ? "" : current_user.name
    end
  end

  def create
    @order = current_cart.order

    if isAdmin?
      user = User.new()
      user.name = params[:name] unless params[:name].nil?
      user.email = params[:email] unless params[:email].nil?
      user.zip = params[:order][:zip]
      user.address = params[:order][:delivery_address]
      user.phone = params[:phone]
      user.password = user.password_confirmation = generate_password

      UserMailer.invoice_email(user, @order).deliver_now if not user.email.empty? 
    elsif user_signed_in? && !current_user.email.nil?
      UserMailer.invoice_email(current_user, @order).deliver_now
    end

    if @order.update_attributes(order_params)
      session[:cart_token] = nil
      updateProductQty @order

      if user_signed_in? 
        redirect_to order_path @order 
      else
        redirect_to products_path, notice: "Tak for din bestilling" 
      end
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
