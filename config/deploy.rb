
role :app_server, "linode.gandrew.com"
set :application, "NowPlaying"
set :domain, "linode.gandrew.com"
set :deploy_to, "/var/web/projects/NowPlaying"
set :repository, "svn+ssh://gandrew.com/home/1439/users/.home/repos/nowplaying/trunk"
