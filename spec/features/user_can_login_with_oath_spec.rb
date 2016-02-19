require "rails_helper"

RSpec.describe "User can log in with oauth", type: :feature, vcr: true do
  context "as a new user" do
    it "can log in using oath" do
      visit root_path
      click_on "Login with Github"

      expect(current_path).to eq dashboard_path
    end

    it "can log out" do
      visit root_path
      click_on "Login with Github"
      expect(current_path).to eq dashboard_path
      click_on "Logout"
      expect(current_path).to eq root_path
    end
  end
end
