class UsersController < ApplicationController
  def show
    gs = GithubService.new(current_user)
    @starred_repos = gs.starred_repos
    @followers = gs.followers
    @users = gs.following
    @contributions = gs.yearly_contributions
    @yearly_streak = gs.yearly_streak
    @current_streak = gs.current_streak
    @commit_summary = gs.commit_summary
    @repos = gs.repos
    @orgs = gs.organizations
  end
end
