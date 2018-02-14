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
    unless params[:email].nil?
      if current_user.email.nil?
        current_user.email =  params[:email]
        unless current_user.save
          Rails.logger.info("** ---- User did not get updates from order#create ---- **")
          Rails.logger.info(current_user.inspect)
        end
      end
    end

    if @order.update_attributes (
        order_params
    )
      session[:cart_token] = nil
      # render plain: @order.inspect
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order)
      .permit(:delivery_address, :zip, :total, :status, :payment_type) 
  end
end
