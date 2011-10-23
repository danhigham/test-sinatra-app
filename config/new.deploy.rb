require File.join(File.dirname(__FILE__), 'ec2-unicorn-recipe.rb')

set :application, "example-app"
set :repository,  "git://github.com/danhigham/rubymelee.git"
set :deploy_to, "/var/www/example-app"
set :scm, :git
set :user, "ec2-user"
set :use_sudo, false

set :host_header, "_"

# needed to run bundler
default_run_options[:pty] = true

# set this to point to your EC2 keys
ssh_options[:keys] = ["#{ENV['HOME']}/Keys/tactusworks.pem"]

role :web, "ec2-107-22-51-65.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-107-22-51-65.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-107-22-51-65.compute-1.amazonaws.com", :primary => true # This is where Rails migrations will run

namespace :bundler do
  
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'