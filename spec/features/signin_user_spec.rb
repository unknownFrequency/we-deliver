require "rails_helper"

RSpec.feature "User signs in" do
  before do
    @user = User.create!(
      name: "Ruben T", address: "her 12", zip: "7741",
      email: "a@a.a", phone: "20131262", password: "password")
  end


  scenario "with valid credentails" do
    visit "/"
    click_link "Login"
    fill_in "Telefon", with: @user.phone
    fill_in "Password", with: @user.password
    click_button "Log ind"

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_content("Signed in as #{@user.name}.")
    expect(page).not_to have_link("Login")
    expect(page).not_to have_link("Opret konto")
  end
end
