require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Creating product" do
  before do
    @admin = User.create!(admin: 1, email: "ab@a.a", phone: "20177777", password: "password", password_confirmation: "password", name: "xxx")
    @user = User.create!(name: "Ruben T", address: "her 12", zip: "7741", email: "a@a.a", phone: "20131262", password: "password", password_confirmation: "password", name: "xxx")
  end
end
