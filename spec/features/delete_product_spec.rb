require 'rails_helper'

RSpec.feature "Delete a product" do
  before do
    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test"
    )
  end

  scenario "A user deletes a product" do
    visit product_path(@product)

    click_link "Slet"
    expect(page).to have_content("Produktet blev slettet")
    expect(current_path).to eq products_path
  end
end
