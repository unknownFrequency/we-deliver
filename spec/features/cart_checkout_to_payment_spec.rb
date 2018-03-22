require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    #@admin = User.create!(admin: 1, email: "ab@a.a", phone: "20177777", password: "password", password_confirmation: "password", name: "xxx")
    @user = User.create!(address: "her 12", zip: "7741", email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password", name: "xxx")
    # @order = Order.create!(Order id: 1, user_id: 1, total: 0.3e2, created_at: "2018-03-22 08:33:02", updated_at: "2018-03-22 08:33:05", token: nil, status: "cart", payment_type: nil, delivery_address: nil, zip: nil  )
  end

 scenario "unregistered user without email places order" do
   visit "/"
  click_button "Tilføj"
   expect(page).to have_content "1 i kurv"
 end

end