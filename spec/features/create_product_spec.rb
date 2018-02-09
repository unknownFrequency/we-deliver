require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    @admin = User.create!(admin: 1, email: "ab@a.a", phone: "20177777", password: "password", password_confirmation: "password")
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    brand = Brand.create!(name: "Coca-Cola")
    @product = Product.create(name: "Cola", description: "Bubbely", price: 25, brand: brand , user: @admin)
  end

  scenario "User tried to create a new product" do
    login_as(@user)
    visit products_path
    expect(page).not_to have_link("Nyt Produkt")
    visit product_path(1)
    expect(page.current_path).to eq product_path(1) 
  end

  scenario "Admin creates a new product" do
    login_as(@admin)
    visit "/"
    click_link "Nyt Produkt"

    fill_in "product[name]", with: "Fanta"
    fill_in "product[description]", with: "Sodavand med bobler"
    fill_in "product[price]", with: 25
    fill_in "product[brand]", with: "Coca-Cola Company" 
    fill_in "product[category]", with: "Sodavand" 

    click_button "Gem"
    expect(Product.last.user).to eq @admin
    expect(page).to have_css("#flash-key")
    expect(page).to have_content("Produktet er tilføjet")
    expect(page.current_path).to eq product_path(2) 
  end

  scenario "A user fails to create a new proudct" do
    login_as(@admin)
    visit '/products/new'

    fill_in "product[name]", with: ""
    fill_in "product[description]", with: ""
    fill_in "product[price]", with: nil 
    fill_in "product[brand]", with: "" 
    fill_in "product[category]", with: "" 
    
    click_button "Gem"

    expect(page).to have_content("Produktet blev ikke oprettet")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price can't be blank")
    expect(page).to have_content("Brand can't be blank")
    expect(page).not_to have_content("Category can't be blank")
  end
end
