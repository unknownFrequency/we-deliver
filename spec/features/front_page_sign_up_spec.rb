require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.configure do |config|
  config.include ActionView::Helpers::NumberHelper

end

RSpec.feature "Signup" do

  before do
    @admin = User.create!(zip: 8000, admin: 1, email: "b@a.a", phone: "77777777", password: "password", password_confirmation: "password", name: "xxx")

    visit "/"
    page.fill_in "Navn", with: "Bob"
    page.fill_in "Telefon nr.", with: "12312312"
    page.fill_in "Post nr.", with: "7000"
    click_button "Videre"

    @brand = Brand.create!(name: "test");
    @product = Product.create!(stock_item: true, name: "Cola", description: "Bubbely", price: 25, brand_id: 1, user_id: 1)
    @product2 = Product.create!(stock_item: true, name: "Mola", description: "Bubbely", price: 0.3e2, brand_id: 1, user_id: 1)
    @product2.description ="Test"
    @product2.save!
  end

  scenario "user adds product and clicks cart" do
    expect(page).to have_current_path products_path
    expect(User.first.id).to equal 1
    expect(User.last.id).to equal  2
    expect(@product.id).to equal 1
    visit product_path(@product)

    expect(page).to have_content "Cola"
    fill_in "qty",  with: "2"
    click_button "Køb"

    expect(page).to have_content "2 i kurv"
    click_link "2 i kurv"

    expect(page).to have_content "kr. 50"
    expect(page).to have_current_path cart_path
  end

  scenario "user changes qty" do
    visit product_path(@product)
    fill_in "qty",  with: "2"
    click_button "Køb"

    expect(page).to have_content "2 i kurv"
    click_link "2 i kurv"

    fill_in "qty", with: "1"
    click_button "Opdater antal"
    expect(page).to have_content "1 i kurv"
  end


  scenario "user clicks Bestil button" do
    visit product_path(@product)
    fill_in "qty",  with: "2"
    click_button "Køb"

    click_link "2 i kurv"
    click_link "Bestil"

    expect(page).to have_current_path("/cart/checkout")
    expect(page).to have_content("12312312")

    fill_in  "order_delivery_address", with: "testgade 12"
    click_button "Bestil nu"

    expect(page).to have_current_path "/charges/new?id=2"
    expect(page).to have_content "Beløb at betale: kr. #{number_with_precision(Order.last.total, precision: 2,  strip_insignificant_zeros: true)}"
  end
end
