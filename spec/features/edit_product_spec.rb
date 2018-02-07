require "rails_helper"

RSpec.feature "Edit a product" do
  before do
    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test"
    )
  end

  scenario "A user updates a product" do
    visit products_path
    
    click_link @product.name
    click_link "Rediger"

    fill_in "product[name]", with: "Fanta"
    fill_in "product[description]", with: "Sodavand med bobler"
    fill_in "product[price]", with: 25
    fill_in "product[brand]", with: "Coca-Cola Company" 
    fill_in "product[category]", with: "Sodavand" 
    click_button "Gem"

    expect(page).to have_content("Produktet blev opdateret")
    expect(page.current_path).to eq product_path(@product)
  end

  scenario "A user fails to update a product" do
    visit products_path
    
    click_link @product.name
    click_link "Rediger"

    fill_in "product[name]", with: ""
    fill_in "product[description]", with: ""
    fill_in "product[price]", with: "" 
    fill_in "product[brand]", with: "" 
    fill_in "product[category]", with: "" 
    click_button "Gem"

    expect(page).to have_content("Produktet blev ikke opdateret")
    expect(page.current_path).to eq product_path(@product)
  end
end
