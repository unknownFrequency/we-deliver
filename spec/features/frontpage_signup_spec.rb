require "rails_helper"
Capybara.ignore_hidden_elements = false

RSpec.feature "user visits frontpage" do
  scenario "sees content" do
    visit root_path
    expect(page).to have_content "Velkommen til WeDeliver"
  end

end
