require 'rails_helper'

describe 'GithubService' do

  before do
    visit root_path
    click_on "Login with Github"
    user = generate_user
    @service = GithubService.new(user)
  end

  context "starred repos" do
    it 'collects starred repos' do
      VCR.use_cassette("starred_repos") do
        starred = @service.starred_repos
        star1 = starred.first
        expect(star1[:name]).to eq("api_curious")
        expect(starred.count).to eq(3)
      end
    end
  end

  context "followers" do
    it "prints a list of followers" do
      VCR.use_cassette("followers") do
        followers = @service.followers
        follower = followers.first

        expect(followers.count).to eq(6)
        expect(follower[:login]).to eq("mikedao")
      end
    end
  end

  context "following" do
    it "prints a list of users I follow" do
      VCR.use_cassette("following") do
        followed_users = @service.following
        followed_user = followed_users.first

        expect(followed_users.count).to eq(1)
        expect(followed_user[:login]).to eq('brantwellman')
      end
    end
  end

  context "yearly_contributions" do
    it "finds my yearly contributions" do
      VCR.use_cassette("contributions") do
        contribution = @service.yearly_contributions
        expect(contribution.first).to eq("574 total")
      end
    end
  end

  context "commits" do
    it "prints recent commits" do
      VCR.use_cassette("commits") do
        commits = @service.commit_summary
        expect(commits.count).to eq(7)
        expect(commit.class).to eq("string")
      end
    end
  end


end
