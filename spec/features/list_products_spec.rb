require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Listing products" do
  before do
    @user = User.create!(name: "Ruben T", address: "her 12", zip: "7741", email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    @admin = User.create!(admin: 1, email: "b@a.a", phone: "77777777", password: "password", password_confirmation: "password", name: "xxx")

    @brand = Brand.create(name: "test");
    @product1 = Product.create!(stock_item: true, name: "Cola", description: "Bubbely", price: 25, brand_id: 1, user_id: @user.id)
    @product2 = Product.create!(name: "Colaz", description: "Bubbely", price: 25, brand_id: 1, user_id: @user.id)
  end

  scenario "admin ser Nyt Produkt" do
    login_as(@admin)
    visit products_path
    expect(page).to have_link("Nyt Produkt")
  end

  scenario "user does not see Nyt Produkt" do
    login_as(@user)
    visit products_path
    expect(page).to_not have_link("Nyt Produkt")
  end

  scenario "user adds product to cart" do
    login_as(@user)
    visit products_path
    expect(@product1).to be_a_kind_of(Product)
    # click_button("#add-#{@product1.name.downcase}")
    # find("#add-#{@product1.name.downcase}").click
    click_on @product1.name

    expect(page).to have_current_path(cart_path)
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
    expect(page).to have_content(@product1.brand.name)
    expect(page).to have_content(@product2.brand.name)
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
    expect(page).not_to have_content(@product1.brand.name)
    expect(page).not_to have_content(@product2.brand.name)
    # expect(page).not_to have_content(@product1.category)
    # expect(page).not_to have_content(@product2.category)

    within ("span.error") do 
      expect(page).to have_content("Ingen produkter")
    end
  end
end
