class Order < ApplicationRecord
  has_many :items, class_name: 'OrderItem'

  PAYMENT_TYPES = {
    0 => "Mobile Pay",
    1 => "PayPal"
  }
end
