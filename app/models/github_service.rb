class GithubService
  attr_reader :connection

  def initialize(current_user)
    @current_user = current_user
    @connection = Faraday.new("https://api.github.com")
  end

  def starred_repos
    response = connection.get("/users/#{@current_user.nickname}/starred")
    raw_data = response.body
    data = JSON.parse(raw_data)
  end

end
