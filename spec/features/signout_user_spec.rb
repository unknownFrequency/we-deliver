require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "Signout user" do
  before do
    @user = User.create!(phone: "12312312", password: "password", password_confirmation: "password")

    visit "/"
    click_link "Login"
    fill_in "Telefon", with: @user.phone
    fill_in "Password", with: @user.password
    click_button "Log ind"
  end

  scenario "logout" do
    visit "/"
    click_link "Log ud"
    expect(page).to have_content("Du er logged ud")
    expect(page).not_to have_content("Log ud")
  end
end
