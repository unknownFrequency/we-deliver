require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    @admin = User.create!(admin: 1, email: "ab@a.a", phone: "20177777", password: "password", password_confirmation: "password", name: "xxx")
    @user = User.create!(name: "Ruben T", address: "her 12", zip: "7741", email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    @brand = Brand.create!(name: "Coca")
    @category = Category.create(name: "Sodavand")
    @product1 = Product.create!(name: "Cola", description: "Bubbely", qty: 21, price: 25, brand_id: @brand.id , user: @admin)
    @product2 = Product.create!(name: "Fanta", description: "Bubbely", qty: 21, price: 25, brand_id: @brand.id , user: @admin)
    @categoriesProduct = CategoriesProduct.create!(product_id: @product1.id, category_id: @category.id)
  end

  scenario "Admin creates order" do
    expect(@product1).to be_a_kind_of(Product)
    expect(@category).to be_a_kind_of(Category)
    expect(@categoriesProduct).to be_a_kind_of(CategoriesProduct)

    login_as(@admin)
    visit cart_path

    fill_in "Produkt", with: "Shampoo"
    fill_in "Antal", with: "789"
    fill_in "Pris", with: "12341234"
    click_button "Tilføj"

    expect(OrderItem.last.name).to eq "Shampoo"
    expect(page.current_path).to eq cart_path
    expect(page).to have_content("Shampoo")
    expect(page).to have_content("789 stk.")
    expect(page).to have_content("12341234 kr.")
    expect(page).to have_content("Ialt: 12341234 kr.")

    fill_in "Produkt", with: "Atombombe"
    fill_in "Antal", with: "1"
    fill_in "Pris", with: "107"
    click_button "Tilføj"

    expect(page.current_path).to eq cart_path
    expect(page).to have_content("Atombombe")
    expect(page).to have_content("1 stk.")
    expect(page).to have_content("12341234 kr.")
    expect(page).to have_content("Ialt: 107 kr.")

    click_button "Gem"

    expect(page.current_path).to eq checkout_path
  end
end
