class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :notifications
  before_action :current_cart
  helper_method :current_cart, :isAdmin?, :number_to_kr, :notifications

  def notifications
    # Message.where(read: :false) if !Message.where(read: :false).first.nil?
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone,:last_name, :zip, :address, :name])
  end

  private


  def current_room
    @room ||= Room.find(session[:current_room]) if session[:current_room]
  end
  helper_method :current_room

  def cart_token
    return @cart_token unless @cart_token.nil?

    session[:cart_token] ||= SecureRandom.hex(8)
    @cart_token = session[:cart_token]
  end

end
