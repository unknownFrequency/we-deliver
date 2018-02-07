require "rails_helper"

RSpec.feature "Signup user" do
  scenario "with valid credentials" do
    visit products_path 
    click_link "Opret konto"
    fill_in "Telefon", with: "20131262"
    fill_in "Email", with: "rt@hshop.dk"
    fill_in "Password", with: "password"
    fill_in "Password igen", with: "password"
    click_button "Opret"

    # expect(page).to have_content('Din konto blev oprettet')
  end

  scenario "without valid credentials" do
    visit products_path 
    click_link "Opret konto"
    fill_in "Telefon", with: ""
    fill_in "Email", with: ""
    fill_in "Password", with: ""
    fill_in "Password igen", with: ""
    click_button "Opret"

    # expect(page).to have_content("Konto ikke oprettet")
  end
end
