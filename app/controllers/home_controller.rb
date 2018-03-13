class HomeController < ApplicationController
  def index
    @generated_password = generate_password
  end

  private

  def generate_password
    random_string = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
    (0...8).map { random_string[rand(random_string.length)] }.join
  end
end
