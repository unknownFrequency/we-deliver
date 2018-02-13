require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Edit a product" do
  before do
    @admin = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741", admin: 1,
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")

    brand = Brand.create(name: "test")
    category = Category.create(name: "Sodavand")

    @product = Product.create(
      name: "test", description: "test", price: 100.5,
      user_id: @admin.id, brand_id: brand.id
    )
    expect(@product).to be_a_kind_of(Product)
    expect(category).to be_a_kind_of(Category)
    @categoriesProduct = CategoriesProduct.create!(product_id: @product.id, category_id: category.id)
  end

  scenario "Admin  updates a product" do
    login_as(@admin)
    visit products_path
    
    click_link @product.name
    click_link "Rediger"

    fill_in "product[name]", with: "Fanta"
    fill_in "product[description]", with: "Sodavand med bobler"
    fill_in "product[price]", with: "1176786"
    select "test", from: "product[brand_id]" 
    select "Sodavand", from: "category_id" 
    click_button "Gem"

    visit product_path(Product.where(name: "Fanta").first)

    expect(page).to have_content("Fanta")
    expect(page).to have_content("Sodavand med bobler")
    expect(page).to have_content("1176786")
    expect(page).to have_content("Sodavand")
    expect(page.current_path).to eq product_path(@product)
  end

  scenario "A user fails to update a product" do
    login_as(@admin)
    visit products_path
    
    click_link @product.name
    click_link "Rediger"

    fill_in "product[name]", with: ""
    fill_in "product[description]", with: ""
    fill_in "product[price]", with: "" 
    select "", from: "product[brand_id]" 
    # fill_in "product[category]", with: "" 
    click_button "Gem"

    expect(page).to have_content("Produktet blev ikke opdateret")
    expect(page.current_path).to eq product_path(@product)
  end
end
