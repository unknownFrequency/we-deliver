require 'rails_helper'

RSpec.feature "Showing an product" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    login_as(@user)

    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test", user: @user
    )
  end
  
  scenario "A user views an article" do
    visit products_path
    click_link @product.name

    expect(page).to have_content(@product.name)
    expect(page).to have_content(@product.brand)
    expect(page).to have_content(@product.description)
    expect(@product.price).to be_kind_of(Float)
    expect(page).to have_content(@product.category)
  end
end
