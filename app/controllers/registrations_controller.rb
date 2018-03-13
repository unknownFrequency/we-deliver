class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        # respond_with resource, location: after_sign_up_path_for(resource)
        redirect_to products_path, flash: { notice: "Tak, du er nu registreret. \n Du skulle have modtaget en sms med et password så du kan se din faktura" }
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
   else
     clean_up_passwords resource
     set_minimum_password_length
     resource.errors.full_messages.each {|x| flash[x] = x}
     redirect_to root_path
   end
  end

  protected

  def after_sign_up_path_for(resource)
    # '/an/example/path' # Or :prefix_to_your_route
    redirect_to products_path, flash: { notice: "Tak, du er nu registreret. \n Du skulle have modtaget en sms med et password så du kan se din faktura" }
  end

end
