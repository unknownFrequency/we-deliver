class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :authentication_keys => [:phone] 
  validates :email, uniqueness: true, presence: false
  validates :phone ,uniqueness: true, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  has_many :products



  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
