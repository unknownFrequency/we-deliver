class ChargesController < ApplicationController

  def new
    order = Order.find(params[:id])

    if order.user_id == current_user.id 
      @total = order.total 
    else
      redirect_back fallback_location: root_path, notice: "Vi undskylder... noget gik galt"
    end
  end

  def create
    # Amount in cents
    @amount = params[:amount].to_i * 100

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken] # representing the payment method provided
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'weDeliver betaling',
      :currency    => 'dkk'
    )

    redirect_to products_path, notice: "Tak for din bestilling. Vi ses om lidt!"

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
