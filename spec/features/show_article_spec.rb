require 'rails_helper'

RSpec.feature "Showing an product" do
  before do
    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test"
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
