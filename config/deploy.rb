# config valid for current version and patch releases of Capistrano
lock "~> 3.12.0"
server '18.224.69.99', port:22, roles: [:web, :app, :db], primary: true

set :application, "metadata_store_application"
set :repo_url, "https://github.com/vijayalaxmi-nayak/MetadataStore"

set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :user,            'ubuntu'
set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :ssh_options, {
  user: fetch(:user),
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w[/home/amagi/Downloads/vijayalaxmi.pem]
}
set :rvm_ruby_version, '2.3.8'
set :passenger_restart_with_sudo, true
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :format,        :pretty
set :log_level,     :debug
set :keep_releases, 5

set :linked_dirs,  %w{log tmp/pids tmp/cache}

namespace :deploy do    

  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after :finishing,     :restart_nginx do
  on roles(:app) do
    execute "sudo pkill nginx"
    execute "sudo ~/nginx-new/sbin/nginx"
  end
  end
end

namespace :logs do
  desc 'Tail application logs'
  task :tail_app do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:stage)}.log"
    end
  end
end

