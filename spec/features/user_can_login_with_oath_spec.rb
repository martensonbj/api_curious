require "rails_helper"

RSpec.describe "User can log in with oauth", type: :feature, vcr: true do
  context "as a new user" do
    it "can log in using oath" do
      visit root_path
      click_on "Login with Github"

      expect(current_path).to eq dashboard_path
      expect(page).to have_content "martensonbj"
    end
  end
end
