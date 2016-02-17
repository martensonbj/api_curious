class GithubService
  attr_reader :connection

  def initialize(current_user)
    @current_user = current_user
    @connection = Faraday.new("https://api.github.com")
    @connection.headers = {"User-Agent"=>"Faraday v0.9.2", "Authorization" => "token #{@current_user.token}"}
  end

  def starred_repos
    response = connection.get("/users/#{@current_user.nickname}/starred")
    raw_data = response.body
    data = JSON.parse(raw_data)
  end

  def followers
    response = connection.get("/users/#{@current_user.nickname}/followers")
    raw_data = response.body
    data = JSON.parse(raw_data)
  end

  def following
    response = connection.get("/users/#{@current_user.nickname}/following")
    raw_data = response.body
    data = JSON.parse(raw_data)
  end

end
