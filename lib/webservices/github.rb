
np_namespace "github" do |ns|
  ns.route 'user_info', [:username], {:cache => false} do |username|
    GitHub::API.user(username)
  end
  
  ns.route "commits", [:username, :repo] do |username, repo|
    GitHub::API.commits(username, repo)
  end
  
  ns.route "commit", [:username, :repo, :id] do |username, repo, id|
    GitHub::API.commit(username, repo, id)
  end
end
