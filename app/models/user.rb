class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :authentication_keys => [:phone] 
  validates :email, uniqueness: true, presence: false
  validates :phone ,uniqueness: true

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
