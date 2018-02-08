require "rails_helper"

RSpec.describe "Products", type: :request do
  before do
    @user = User.create!(email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password")
    @admin = User.create!(admin: 1, email: "b@a.a", phone: "77777777", password: "password", password_confirmation: "password")
    @product = Product.create(
      name: "test", brand: "test",
      description: "test", price: 100.5,
      category: "test", user: @admin
    )
  end

  describe "GET /products/new" do
    context "with admin" do
      before do 
        login_as(@admin)
        get "/products/new"
      end

      it "shows edit page" do
        expect(response.status).to eq 200
      end
    end

    context "without user" do
      before { get "/products/new" }

      it "redirects back" do
        expect(response.status).to eq 302
      end
    end

    context "with user" do
      login_as(@user)
      before { get "/products/new" }

      it "redirects back" do
        expect(response.status).to eq 302
      end
    end
  end

  describe "GET /products/:id/edit" do
    context "with admin" do
      before do 
        login_as(@admin)
        get "/products/#{@product.id}/edit"
      end

      it "shows edit page" do
        expect(response.status).to eq 200
      end
    end

    context "without user" do
      before { get "/products/#{@product.id}/edit" }

      it "redirects back" do
        expect(response.status).to eq 302
      end
    end

    context "with user" do
      login_as(@user)
      before { get "/products/#{@product.id}/edit" }

      it "redirects back" do
        expect(response.status).to eq 302
      end
    end
  end

  describe "GET /products/:id" do
    context "show product without user" do
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
