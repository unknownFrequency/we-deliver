class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def resource_not_found
    ## Will be overwritten in the individual controllers
    ## for individual error messages
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:phone,:last_name, :zip, :address]
    )
  end

end
