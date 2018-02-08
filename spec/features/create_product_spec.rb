require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    login_as(@user)
  end

  scenario "A user creates a new product" do
    visit "/"
    click_link "Nyt Produkt" #capabaya func

    fill_in "product[name]", with: "Fanta"
    fill_in "product[description]", with: "Sodavand med bobler"
    fill_in "product[price]", with: 25
    fill_in "product[brand]", with: "Coca-Cola Company" 
    fill_in "product[category]", with: "Sodavand" 

    click_button "Gem"
    expect(page).to have_css("#flash-key")
    # element = page.find("#flash-key", visible: :all, text: "Produktet er tilføjet")
    expect(page).to have_content("Produktet er tilføjet")
    expect(page.current_path).to eq(product_path(1))
  end

  scenario "A user fails to create a new proudct" do
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
