class HomeController < ApplicationController
  def index
    @generated_password = generate_password
  end

end
