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

  context "yearly_streak" do
    it "finds my longest streak" do
      VCR.use_cassette("streak") do
        streak = @service.yearly_streak
        expect(streak.first).to eq("13 days")
      end
    end
  end


    context "current_streak" do
      it "finds my current streak" do
        VCR.use_cassette("streak") do
          streak = @service.current_streak
          expect(streak.first).to eq("3 days")
        end
      end
    end

  context "commits" do
    it "prints recent commits" do
      VCR.use_cassette("commits") do
        commits = @service.commit_summary
        commit = commits.first
        expect(commits.count).to_not be_nil
        expect(commit.class).to eq(String)
      end
    end
  end

  context "repos" do
    it "prints a list of repos" do
      VCR.use_cassette("repos") do
        repos = @service.repos
        repo = repos.first

        expect(repos.count).to_not be_nil
        expect(repo[:name]).to include("api_curious")
    end
    end
  end

  context "organizations" do
    it "prints a list of organizations" do
      VCR.use_cassette("organizations") do
        organizations = @service.organizations
        org = organizations.first

        expect(organizations.count).to_not be_nil
        expect(org[:login]).to eq("TuringTestOrganization")
    end
    end
  end

  context "open_pull_requests" do
    it "prints a list of pull_requests" do
      VCR.use_cassette("pull_requests") do
        pull_requests = @service.open_pull_requests
        request = pull_requests.first

        expect(pull_requests.count).to_not be_nil
        expect(pull_requests.count).to be > 1
        expect(request.class).to eq(String)
    end
    end
  end

  context "following_users" do
    it "prints a list of users I am following with recent activity" do
      VCR.use_cassette("followed_user_info") do
        data = @service.following_users
        data_set = data.first

        expect(data.count).to_not be_nil
        expect(data.class).to eq(Array)
        expect(data_set.class).to eq(Hash)
        expect(data_set[:nickname]).to include("brantwellman")
      end
    end
  end

  context "commit_summary_for_user" do
    it "parses commits per user" do
      VCR.use_cassette("commit_summary_for_user", :record => :new_episodes) do
        user = @service.following_users.first[:nickname]
        messages = @service.commit_summary_for_user(user)
        message = messages.first

        expect(user).to_not be_nil
        expect(messages.count).to be > 0
        expect(messages.class).to eq(Array)
        expect(message.class).to eq(String)
      end
    end
  end

end
