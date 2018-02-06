require "rails_helper"

RSpec.feature "Creating product" do
  scenario "A user creates a new product" do
    visit "/"
    click_link "Nyt Produkt" #capabaya func

    fill_in "products[name]", with: "Fanta"
    fill_in "products[description]", with: "Sodavand med bobler"
    fill_in "products[price]", with: 25
    fill_in "products[brand]", with: "Coca-Cola Company" 
    fill_in "products[category]", with: "Sodavand" 

    click_button "Gem"
    expect(page).to have_content("Produktet er tilføjet")
    expect(page.current_path).to eq(product_path(1))
  end

  scenario "A user fails to create a new proudct" do
    visit '/products/new'

    fill_in "products[name]", with: ""
    fill_in "products[description]", with: ""
    fill_in "products[price]", with: nil 
    fill_in "products[brand]", with: "" 
    fill_in "products[category]", with: "" 
    
    click_button "Gem"

    expect(page).to have_content("Produktet blev ikke oprettet")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price can't be blank")
    expect(page).to have_content("Brand can't be blank")
    expect(page).to have_content("Category can't be blank")
  end
end
