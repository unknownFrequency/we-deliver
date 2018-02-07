require "rails_helper"

RSpec.describe "Products", type: :request do
  before do
    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test"
    )
  end

  describe "GET /products/:id" do
    context "with existing product" do
      before { get "/products/#{@product.id}" }

      it "handles existing product" do
        expect(response.status).to eq 200
      end
    end

    context "with existing product" do
      before { get "/products/xxx" }

      it "handles non-existing products" do
        expect(response.status).to eq 302
        flash_message = "Produktet kunne ikke findes"
        expect(flash[:error]).to eq flash_message
      end
    end
  end
  
end
