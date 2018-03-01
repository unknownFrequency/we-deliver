class ShoppingCart
  #allow us to use: current_cart.total
  delegate :total, to: :order

  def initialize(token:, user: nil)
    @token = token
    @user = user
  end

  def order
    # if order has not been assigned, set total to 0
    if @user
      @order ||= Order.find_or_create_by(token: @token, status: "cart", user_id: @user.id) do |order|
        order.total = 0
      end
    else
      @order ||= Order.find_or_create_by(token: @token, status: "cart") do |order|
        order.total = 0
      end
    end
  end

  def add_item(product_id:, qty: 1)
    product = Product.find(product_id)
    order_item = order.items.find_or_initialize_by(product_id: product_id)
    order_item.price = product.price
    order_item.qty += qty.to_i

    ActiveRecord::Base.transaction do
      order_item.save!
      update_total!
    end
  end

  def remove_item(id:)
    ActiveRecord::Base.transaction do
      order.items.destroy(id)
      update_total!
    end
  end

  def items_count
    order.items.sum(:qty)
  end

  private

  def update_total!
    order.total = order.items.sum("qty * price")
    order.save
  end
end
