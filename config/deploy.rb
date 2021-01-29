# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "stackoverflow"
set :repo_url, "https://github.com/sasha370/stackoverflow.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/sasha370/stackoverflow"
set :user, 'sasha370'
# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

set :keep_assets, 2
# set :assets_roles, [:web, :app]
# set :assets_prefix, 'prepackaged-assets'
# set :assets_manifests, ['app/assets/config/manifest.js']
# set :rails_assets_groups, :assets

after 'deploy:publishing', 'unicorn:restart'
