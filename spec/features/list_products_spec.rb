require "rails_helper"

RSpec.feature "Listing products" do
  before do
    @product1 = Product.create(name: "Cola", description: "Bubbely", price: 25, brand: "Coca-Cola", category: "Sodavand")
    @product2 = Product.create(name: "Cola", description: "Bubbely", price: 25, brand: "Coca-Cola", category: "Sodavand")
  end

  scenario "We list all products" do
    visit products_path

    expect(page).to have_content(@product1.name)
    expect(page).to have_content(@product2.name)
    expect(page).to have_content(@product1.description)
    expect(page).to have_content(@product2.description)
    expect(page).to have_content(@product1.price)
    expect(page).to have_content(@product2.price)
    expect(page).to have_content(@product1.brand)
    expect(page).to have_content(@product2.brand)
    expect(page).to have_content(@product1.category)
    expect(page).to have_content(@product2.category)
  end
end
