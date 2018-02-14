class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :authentication_keys => [:phone] 

  validates :email, allow_blank: true, presence: false
  validates :phone , uniqueness: true, presence: true, numericality: true, length: { is: 8 }, on: :create 
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_many :orders
  has_many :products

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
