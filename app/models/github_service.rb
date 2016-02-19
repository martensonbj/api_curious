require 'open-uri'

class GithubService
  attr_reader :connection

  def initialize(current_user)
    @current_user = current_user
    @connection = Faraday.new("https://api.github.com")
    @connection.headers = {"User-Agent"=>"Faraday v0.9.2", "Authorization" => "token #{@current_user.token}"}
  end

  def starred_repos
    parse(connection.get("/users/#{@current_user.nickname}/starred"))
  end

  def followers
    parse(connection.get("/users/#{@current_user.nickname}/followers"))
  end

  def following
    parse(connection.get("/users/#{@current_user.nickname}/following"))
  end

  def year_joined
    data = Nokogiri::HTML(open("https://github.com/#{@current_user.nickname}"))
    data.xpath("//*[@id='js-pjax-container']/div/div/div[1]/ul/li/time").text
  end

  def yearly_contributions
    data = Nokogiri::HTML(open("https://github.com/#{@current_user.nickname}"))
    stats = []
    stats << data.xpath("//*[@id='contributions-calendar']/div[3]/span[2]").text
    stats << data.xpath("//*[@id='contributions-calendar']/div[3]/span[3]").text
    stats
  end

  def yearly_streak
    data = Nokogiri::HTML(open("https://github.com/#{@current_user.nickname}"))
    stats = []
    stats << data.xpath("//*[@id='contributions-calendar']/div[4]/span[2]").text
    stats << data.xpath("//*[@id='contributions-calendar']/div[4]/span[3]").text
    stats
  end

  def current_streak
    data = Nokogiri::HTML(open("https://github.com/#{@current_user.nickname}"))
    stats = []
    stats << data.xpath("//*[@id='contributions-calendar']/div[5]/span[2]").text
    stats << data.xpath("//*[@id='contributions-calendar']/div[5]/span[3]").text
    stats
  end

  def commit_summary
    push_events = parse(connection.get("/users/#{@current_user.nickname}/events")).select do |event|
      event[:type] == "PushEvent"
    end
    commit_messages = push_events.map do |event|
      event[:payload][:commits].map do |commit|
        if @current_user.nickname == commit[:author][:name]
          commit[:message]
        end
      end
    end
    commit_messages.map! do |message|
      message.compact!
    end
    commit_messages.flatten
  end

  def repos
    parse(connection.get("/users/#{@current_user.nickname}/repos"))
  end

  def organizations
    parse(connection.get("/users/#{@current_user.nickname}/orgs"))
  end

  def open_pull_requests
    pull_requests = parse(connection.get("/users/#{@current_user.nickname}/events")).select do |event|
      event[:type] == "PullRequestEvent"
    end
    open_requests = pull_requests.map do |request|
      if request[:actor][:login] == @current_user.nickname && request[:payload][:action] == "opened"
        request[:payload][:pull_request][:html_url]
      end
    end
    open_requests.compact!
  end

  def following_users
    following.map do |this_user|
      user = this_user[:login]
      messages = commit_summary_for_user(user)[0...5]
      {nickname: user, commits: messages}
    end
  end

  def commit_summary_for_user(given_user)
    push_events = parse(connection.get("/users/#{given_user}/events")).select do |event|
      event[:type] == "PushEvent"
    end
    commit_messages = push_events.map do |event|
      event[:payload][:commits].map do |commit|
        if given_user == event[:actor][:login]
          commit[:message]
        end
      end
    end
    commit_messages.flatten
  end

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end

end
