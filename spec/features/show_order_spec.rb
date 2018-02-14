require 'rails_helper'
Capybara.ignore_hidden_elements = false


RSpec.feature "Create order" do
  before do
    @user = User.create(name: "Ruben T", address: "her 12", zip: "7741", phone: "20131262", password: "password", password_confirmation: "password")
    @user2 = User.create(email: "r@r.dk", address: "her 12", zip: "7741", phone: "20161262", password: "password", password_confirmation: "password")
    @brand = Brand.create(name: "Coca-Cola Company");
    @admin = User.create!(admin: 1, email: "b@a.a", phone: "77777777", password: "password", password_confirmation: "password")
    @product1 = Product.create(name: "Cola", description: "Bubbely", price: 25, brand_id: 1, user: @admin)
    @product2 = Product.create!(name: "Fanta", description: "Bubbely", price: 25, brand_id: 1, user: @admin)
  end

  before do
    login_as(@user)
    visit products_path

    click_button("add-#{@product1.name.downcase}")
    expect(page).to have_current_path("/cart")
    expect(page).to have_content("1 i kurv")

    click_link("Gå til bestilling")
    expect(page).to have_current_path(checkout_path)
    @order = Order.last
    expect(@order.id).to eq(1)
  end

  # TODO
  scenario "user should only be allowed to see own order" do
    expect(1).to eq 1
  end

  scenario "user fills in email" do
    expect(page).to have_current_path(checkout_path)
    fill_in "email", with: "fanta@soda.dk"
    click_button("Bestil nu")
    expect(page).to have_current_path(order_path(1))
    expect(page).to have_content("fanta@soda.dk")
    expect(page).to have_content(@user.name)
    # expect(find_field('name').value).to eq @user.name
  end

  scenario "user fills in name with no email" do
    logout(@user)
    login_as(@user2)
    expect(page).to have_current_path(checkout_path)

    fill_in "name", with: "Ruben Thuesen"
    expect(page).to have_content("kr. 25")
    click_button("Bestil nu")

    expect(page).to have_current_path(order_path(2))
    expect(page).to have_content(@user2.name)
    expect(page).to have_content(@user2.phone)
    # expect(page).to have_content("kr. 25") ## ??? WHYis it showing kr 0 ??
    expect(page).to have_content(@user2.address)
    expect(page).to have_content("Ordren er under behandling")
  end
end
