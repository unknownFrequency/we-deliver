require 'rails_helper'

RSpec.feature "Showing an product" do
  before do
    @admin = User.create!(admin: 1, email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    @user = User.create!(email: "b@a.a", phone: "30131269", password: "password", password_confirmation: "password")

    @brand = Brand.create(name: "testtest")
    @category = Category.create(name: "cat")

    @product = Product.create(
      name: "test", brand_id: 1, qty: 10,
      description: "test", price: 100.5,
      user: @admin
    )

    @catProduct = CategoriesProduct.create(product_id: 1, category_id: 1)
  end
  
  scenario "Admin views a product" do
    login_as(@admin)
    visit products_path
    click_link @product.name

    expect(page).to have_content(@product.name)
    expect(page).to have_content(@brand.name)
    expect(page).to have_content(@category.name)
    expect(page).to have_content(@product.description)
    expect(page).to have_content(@product.qty)
    # expect(page).to have_content(@product.category)
    expect(page).to have_link("Rediger")
    expect(page).to have_link("Slet")
  end

  scenario "user not signed in, views a product" do
    visit products_path
    click_link @product.name

    expect(page).to have_content(@brand.name)
    expect(page).to have_content(@product.description)
    # expect(page).to have_content(@product.category)
    expect(page).not_to have_link("Rediger")
    expect(page).not_to have_link("Slet")
  end

  scenario "user signed in, views a product" do
    login_as(@user)
    visit products_path
    click_link @product.name

    expect(page).to have_content(@brand.name)
    expect(page).to have_content(@product.description)
    # expect(@product.price).to be_kind_of(Decimal)
    # expect(page).to have_content(@product.category)
    expect(page).not_to have_link("Rediger")
    expect(page).not_to have_link("Slet")
  end
end
