require 'rails_helper'

RSpec.describe GithubService, type: :feature do

  describe '#starred_repos' do
    it 'should log in an authenticated user' do
      # Use when hitting methods that make api calls
      # VCR.use_cassette("starred_repos") do
      #   user = User.create(provider: "github", uid:"1", nickname: "brenna", email: "brenna@example.com", image: nil, token: "12345")
      #   sr = GithubService.new(user).starred_repos
      #   sr.first
      #   # expect(sr.first["name"]).not_to be_nil
      #   expect(sr.first["name"]).to eq("user")
      # end
    end
  end

end
