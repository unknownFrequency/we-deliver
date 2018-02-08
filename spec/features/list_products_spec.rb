require "rails_helper"

RSpec.feature "Listing products" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    @product1 = Product.create(name: "Cola", description: "Bubbely", price: 25, brand: "Coca-Cola", category: "Sodavand", user: @user)
    @product2 = Product.create(name: "Colaz", description: "Bubbely", price: 25, brand: "Coca-Cola", category: "Sodavand", user: @user)
  end

  scenario "all products without user" do
    visit products_path
    expect(page).not_to have_css("#phone")
    expect(page).not_to have_link("Nyt Produkt")

    expect(page).to have_content(@product1.name)
    expect(page).to have_content(@product2.name)
    expect(page).to have_content(@product1.description)
    expect(page).to have_content(@product2.description)
    expect(page).to have_content(@product1.price)
    expect(page).to have_content(@product2.price)
    expect(page).to have_content(@product1.brand)
    expect(page).to have_content(@product2.brand)
    expect(page).to have_content(@product1.category)
    expect(page).to have_content(@product2.category)
  end

  scenario "all products with user" do
    login_as(@user)
    visit products_path

    expect(page).to have_content(@user.phone)
    expect(page).to have_css("#phone")

    expect(page).to have_link("Nyt Produkt")
    expect(page).to have_content(@product1.name)
    expect(page).to have_content(@product2.name)
    expect(page).to have_content(@product1.description)
    expect(page).to have_content(@product2.description)
    expect(page).to have_content(@product1.price)
    expect(page).to have_content(@product2.price)
    expect(page).to have_content(@product1.brand)
    expect(page).to have_content(@product2.brand)
    expect(page).to have_content(@product1.category)
    expect(page).to have_content(@product2.category)
  end

  scenario "We list all products" do
    Product.delete_all
    visit products_path

    expect(page).not_to have_content(@product1.name)
    expect(page).not_to have_content(@product2.name)
    expect(page).not_to have_content(@product1.description)
    expect(page).not_to have_content(@product2.description)
    expect(page).not_to have_content(@product1.price)
    expect(page).not_to have_content(@product2.price)
    expect(page).not_to have_content(@product1.brand)
    expect(page).not_to have_content(@product2.brand)
    expect(page).not_to have_content(@product1.category)
    expect(page).not_to have_content(@product2.category)

    within ("span.error") do 
      expect(page).to have_content("Ingen produkter")
    end
  end
end
