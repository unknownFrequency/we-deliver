class Order < ApplicationRecord
  has_many :items, class_name: 'OrderItem'
  has_one :user
  accepts_nested_attributes_for :user

  PAYMENT_TYPES = {
    0 => "Mobile Pay",
    1 => "PayPal"
  }
end
