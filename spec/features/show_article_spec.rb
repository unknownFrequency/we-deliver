require 'rails_helper'

RSpec.feature "Showing an product" do
  before do
    @admin = User.create!(admin: 1, email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    @user = User.create!(email: "b@a.a", phone: "30131269", password: "password", password_confirmation: "password")

    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test", user: @admin
    )
  end
  
  scenario "Amin views a product" do
    login_as(@admin)
    visit products_path
    click_link @product.name

    expect(page).to have_content(@product.name)
    expect(page).to have_content(@product.brand)
    expect(page).to have_content(@product.description)
    expect(@product.price).to be_kind_of(Float)
    expect(page).to have_content(@product.category)
    expect(page).to have_link("Rediger")
    expect(page).to have_link("Slet")
  end

  scenario "user not signed in, views a product" do
    visit products_path
    click_link @product.name

    expect(page).to have_content(@product.name)
    expect(page).to have_content(@product.brand)
    expect(page).to have_content(@product.description)
    expect(@product.price).to be_kind_of(Float)
    expect(page).to have_content(@product.category)
    expect(page).not_to have_link("Rediger")
    expect(page).not_to have_link("Slet")
  end

  scenario "user signed in, views a product" do
    login_as(@user)
    visit products_path
    click_link @product.name

    expect(page).to have_content(@product.name)
    expect(page).to have_content(@product.brand)
    expect(page).to have_content(@product.description)
    expect(@product.price).to be_kind_of(Float)
    expect(page).to have_content(@product.category)
    expect(page).not_to have_link("Rediger")
    expect(page).not_to have_link("Slet")
  end
end
