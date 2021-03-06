class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :notifications
  before_action :current_cart
  helper_method :current_cart, :isAdmin?, :number_to_kr, :notifications, :send_message, :generate_password

  def generate_password
    random_string = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
    (0...8).map { random_string[rand(random_string.length)] }.join
  end

  def send_message(phone_number, alert_message)
    @twilio_number = "4153600414"
    @client = Twilio::REST::Client.new Rails.configuration.twilio[:account_sid], Rails.configuration.twilio[:auth_token]

    message = @client.api.account.messages.create(
      :from => @twilio_number,
      :to => phone_number,
      :body => alert_message,
    )

    redirect_to sms_new_path, flash: {notice: "Beskeden blev sendt"}
  end

  def notifications
    @unreadMessages = []
    rooms = Room.all
    rooms.each do |room|
      messages = room.messages if room && room.messages

      unless messages.empty?
        messages.each do |message|
          if !message.read
            @unreadMessages.push message
          end
        end
      end
    end

    return @unreadMessages
  end

  def current_cart
    if user_signed_in?
      @current_cart ||= ShoppingCart.new(token: cart_token, user: current_user)
    else
      @current_cart ||= ShoppingCart.new(token: cart_token)
    end
  end


  def number_to_kr(amount)
    number_to_currency(amount, strip_insignificant_zeros: true, :unit=>'kr. ')
  end

  protected

  def resource_not_found
    ## Will be overwritten in the individual controllers
  end

  def isAdmin?
    user_signed_in? && current_user.admin
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone, :zip, :address, :name])
  end

  private

  def current_room
    @room ||= Room.find(session[:current_room]) if session[:current_room]
  end

  def cart_token
    return @cart_token unless @cart_token.nil?
  rescue ActiveRecord::RecordNotFound
    session[:cart_token] ||= SecureRandom.hex(8)
    @cart_token = session[:cart_token]
  end

end
