require "rails_helper"

RSpec.feature "Sending a chat message" do
  before do
    @user = User.create!(name: "RullePops1", email: "ab1@a.a", phone: "11112223", password: "password", password_confirmation: "password")
    @admin = User.create!(admin: 1, name: "RullePops2", email: "ab2@a.a", phone: "11112224", password: "password", password_confirmation: "password")
    # @user3 = User.create!(name: "RullePops3", phone: "11112225", password: "password", password_confirmation: "password")

    @roomName = "#{@user.phone}-#{@user.name}"
    @room = Room.create!(name: @roomName, user_id: @user.id)
    p @room

    login_as @user
  end

  scenario "admin shows in chatroom window" do
    visit room_path(@room)
    # click_link "Skriv med os"

    expect(page).to have_content(@roomName)

    fill_in "message-field", with: "Hej"
    click_button "Send"

    expect(page).to have_content "Hej"
    expect(page).to have_content(@user.name)

    login_as(@admin)
    visit room_path(@room)


    fill_in "message-field", with: "Hvad kan vi gøre for dig?"
    click_button "Send"

    expect(page).to have_content "Hvad kan vi gøre for dig?"
    expect(page).to have_content(@admin.name)
  end
end
