require "rails_helper"

RSpec.feature "Listing products" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    @brand = Brand.create(name: "test");
    @admin = User.create!(admin: 1, email: "b@a.a", phone: "77777777", password: "password", password_confirmation: "password")
    @product1 = Product.create(name: "Cola", description: "Bubbely", price: 25, brand_id: 1, user: @admin)
    @product2 = Product.create!(name: "Colaz", description: "Bubbely", price: 25, brand_id: 1, user: @admin)
  end


  scenario "admin sees Nyt Produkt" do
    login_as(@admin)
    visit products_path
    expect(page).to have_link("Nyt Produkt")
  end

  scenario "user adds product to cart" do
    login_as(@user)
    visit products_path

    click_button("add-#{@product1.name.downcase}")
    expect(page).to have_current_path("/cart")
    expect(page).to have_content("1 i kurv")

    visit products_path
    click_button("add-#{@product2.name.downcase}")
    expect(page).to have_content("2 i kurv")
    expect(page).to have_current_path("/cart")
  end

  scenario "all products without user" do
    visit products_path
    expect(page).not_to have_css("#phone")
    expect(page).not_to have_link("Nyt Produkt")

    page.inspect
    expect(page).to have_content(@product1.name)
    expect(page).to have_content(@product2.name)
    expect(page).to have_content(@product1.description)
    expect(page).to have_content(@product2.description)
    expect(page).to have_content(@product1.price)
    expect(page).to have_content(@product2.price)
    expect(page).to have_content(@brand.name)
  end

  scenario "all products with user" do
    login_as(@user)
    visit products_path

    expect(page).not_to have_link("Nyt Produkt")

    expect(page).to have_content(@product1.name)
    expect(page).to have_content(@product2.name)
    expect(page).to have_content(@product1.description)
    expect(page).to have_content(@product2.description)
    expect(page).to have_content(@product1.price)
    expect(page).to have_content(@product2.price)
    expect(page).to have_content(@product1.brand_id)
    expect(page).to have_content(@product2.brand_id)
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
    expect(page).not_to have_content(@product1.brand_id)
    expect(page).not_to have_content(@product2.brand_id)
    # expect(page).not_to have_content(@product1.category)
    # expect(page).not_to have_content(@product2.category)

    within ("span.error") do 
      expect(page).to have_content("Ingen produkter")
    end
  end
end
