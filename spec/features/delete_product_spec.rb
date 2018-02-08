require 'rails_helper'
Capybara.ignore_hidden_elements = false

RSpec.feature "Delete a product" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    login_as(@user)

    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test", user_id: @user.id
    )
  end

  scenario "A user deletes a product" do
    visit product_path(@product)

    click_link "Slet"
    expect(page).to have_content("Produktet blev slettet")
    expect(current_path).to eq products_path
  end
end
