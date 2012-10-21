require 'bundler/capistrano'
require "rvm/capistrano"                     

set :rvm_type, :system

set :application, "tika"

set :scm, :git
set :repository, "git://github.com/RaulKite/tika.git"

server "155.54.205.183", :web, :app, :db, :primary => true

ssh_options[:port] = 22
ssh_options[:keys] = "~/.ssh/insecure_private_key_vagrant"

set :user, "vagrant"
set :group, "vagrant"
set :deploy_to, "/home/www/tika"
set :use_sudo, false

set :deploy_via, :copy
set :copy_strategy, :export

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  desc "Restart the application"
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  desc "Copy the database.yml file into the latest release"
    task :copy_in_database_yml do
      run "cp #{shared_path}/config/database.yml #{latest_release}/config/"
    end
end
before "deploy:assets:precompile", "deploy:copy_in_database_yml"






