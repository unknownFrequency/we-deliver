require 'rails_helper'

RSpec.describe User, type: :model do
  context "validation tests" do
    before do
    end

    it "ensures phone presence" do
      user = User.new(name: "Ruben", email: "rubyte@protonmail.com", address: "Gl. Aalborgvej 16")
      expect(user).to eq(false)
    end

    it "ensures address presence" do

    end

    it "ensures name presence" do

    end

    it "it should save successfully" do

    end
  end

  context "scope tests" do
  end
end
