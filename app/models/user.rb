class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :authentication_keys => [:phone] 

  validates :name, presence: true
  validates :zip, presence: true
  validates :email, allow_blank: true, presence: false
  validates :phone , uniqueness: true, presence: true, numericality: true, length: { is: 8 }
  validates :password, allow_blank: true, presence: false, length: { minimum: 8 }#, on: :update
  validates :password_confirmation, allow_blank: true, presence: false#, on: :update
  validates :address, presence: false, allow_blank: true, on: :create
  # validates :address, presence: true, on: :update

  has_many :orders
  has_many :products
  has_many :messages
  has_one :room

  after_create :create_chatroom
  after_create :send_password

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  private

  def send_password()
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new Rails.configuration.twilio.account_sid, Rails.configuration.twilio.auth_token
    message = "Login for at se din ordre med \n Telefon nr.: #{self.phone} og \n Password: #{self.password}"

    logger.debug(message)

    message = @client.api.account.messages.create(
      :from => "4153600414",
      # :to => self.phone,
      :to => "+4520131262",
      :body => message,
    )

    redirect_to products_path, flash: { notice: "Tak, du er nu registreret. <br /> Du skulle have modtaget en sms med et password hvis du se din faktura" }
  end

  def create_chatroom
    chatroom_name = "#{self.phone}-#{self.name}"
    Room.create(name: chatroom_name, user_id: self.id)
  end
end
