require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    @admin = User.create!(admin: 1, email: "ab@a.a", phone: "20177777", password: "password", password_confirmation: "password")
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741", 
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    brand = Brand.create!(name: "Coca")
    @category = Category.create(name: "Sodavand")
    @product = Product.create!(name: "Cola", description: "Bubbely", qty: 21, price: 25, brand_id: brand.id , user: @admin)
    expect(@product).to be_a_kind_of(Product)
    expect(@category).to be_a_kind_of(Category)
    @categoriesProduct = CategoriesProduct.create!(product_id: @product.id, category_id: @category.id)
  end

  scenario "User tried to create a new product" do
    login_as(@user)
    visit products_path
    expect(page).not_to have_link("Nyt Produkt")
    visit product_path(1)
    expect(page.current_path).to eq product_path(1) 
  end

  scenario "admin creates a new product" do
    login_as(@admin)
    visit products_path 
    click_link "Nyt Produkt"

    fill_in "product[name]", with: "fanta"
    fill_in "product[description]", with: "sodavand med bobler"
    fill_in "product[price]", with: 25
    fill_in "product[qty]", with: 25
    select "Coca", from: "product[brand_id]"
    select "Sodavand", from: "category_id"
    # fill_in "product[category_id]", with: "sodavand" 

    click_button "Gem"
    expect(Product.last.user).to eq @admin

    visit product_path(Product.last) # it redirects to "Resource not found" if I dont use visit here
    # expect(page).to have_css("#flash-key")
    # expect(page).to have_content("Produktet er tilføjet")
    expect(page).to have_content(Product.last.name)
    expect(page).to have_content("Producent  #{Product.last.brand.name}")
    expect(page).to have_content("Beskrivelse #{Product.last.description}")
    expect(page).to have_content("Antal #{Product.last.qty}")
    expect(page).to have_content("Kategori: #{Product.last.category.name}")
    expect(page.current_path).to eq product_path(2) 
  end

  scenario "Admin fails to create a new proudct" do
    login_as(@admin)
    visit '/products/new'

    fill_in "product[name]", with: ""
    fill_in "product[description]", with: ""
    fill_in "product[price]", with: nil 
    select "", from: "product[brand_id]"
    page.find("#category_id")
    
    click_button "Gem"

    expect(page).to have_content("Produktet blev ikke oprettet")
    # expect(page).to have_content("Name can't be blank")
    # expect(page).to have_content("Description can't be blank")
    # expect(page).to have_content("Price can't be blank")
    # expect(page).not_to have_content("Category can't be blank")
  end
end
