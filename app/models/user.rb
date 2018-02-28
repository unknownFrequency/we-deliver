class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :authentication_keys => [:phone] 

  validates :name, presence: true
  validates :email, allow_blank: true, presence: false
  validates :phone , uniqueness: true, presence: true, numericality: true, length: { is: 8 }, on: :create 
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_many :orders
  has_many :products
  has_many :messages
  has_one :room

  after_create :create_chatroom

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  private

  def create_chatroom
    chatroom_name = "#{self.phone}-#{self.name}"
    Room.create(name: chatroom_name, user_id: self.id)
  end
end
