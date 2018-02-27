require "rails_helper"

RSpec.feature "Sending a chat message" do
  before do
    @user = User.create!(name: "RullePops1", email: "ab1@a.a", phone: "11112223", password: "password", password_confirmation: "password")
    @admin = User.create!(admin: true, name: "RullePops2", email: "ab2@a.a", phone: "11112224", password: "password", password_confirmation: "password")
    # @user3 = User.create!(name: "RullePops3", phone: "11112225", password: "password", password_confirmation: "password")

    @roomName = "#{@user.phone}-#{@user.name}"
    @room = Room.create!(name: @roomName, user_id: @user.id)

    login_as @user
  end

  scenario "heading link shows an unread message" do
  end

  scenario "heading link shows 2 unread messages" do
  end

  scenario "heading contains no unread messages" do
  end

  scenario "admin shows in chatroom window" do
    visit room_path(@room)
    click_link "Skriv med os"

    expect(page).to have_content(@roomName)

    fill_in "message-field", with: "Hej"
    click_button "Send"

    expect(page).to have_content "Hej"
    expect(page).to have_content(@user.name)
    expect(Message.last.read).to eq false
    click_link "Log ud"

    click_link "Login"
    fill_in "user_phone", with: "11112224"
    fill_in "user_password", with: "password"
    click_button "submit-btn"

    expect(page).to have_content(@admin.phone)
    expect(@admin.admin).to eq true

    # expect(page).to have_content("1 ulæst besked") # TODO WHY?
    visit room_path(@room)
    # expect(Message.last.read).to eq true
    fill_in "message-field", with: "Hvad kan vi gøre for dig?"
    click_button "Send"

    expect(page).to have_content "Hvad kan vi gøre for dig?"
    expect(page).to have_content(@admin.name)
  end
end
