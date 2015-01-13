#
# Cookbook Name:: hpf
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#


# ################################################
# Sails App Configuration 
# ################################################
include_recipe 'nodejs'
include_recipe 'git'

nodejs_npm 'sails'

git "#{node['hpf']['application']['deploy_path']}" do
  repository "https://github.com/mbowen000/HPF.git"
  revision "master"
  action :sync
end

execute "npm-install" do
  cwd "#{node['hpf']['application']['deploy_path']}"
  command "npm install"
  user "root"
  group "root"
  action :run
end

# ################################################
# Mongodb Configuration 
# ################################################
include_recipe "mongodb::default"

# ################################################
# Apache Configuration 
# ################################################
include_recipe 'apache2'

# disable default site
apache_site '000-default' do
  enable false
end

# create our site
template "#{node['apache']['dir']}/sites-available/hpf.conf" do
  source 'hpf.conf.erb'
  notifies :restart, 'service[apache2]'
end

# enable our site
apache_site 'hpf' do 
	enable true
end

# enable additional modules required
apache_module 'proxy' do
	enable true
end
apache_module 'proxy_http' do
	enable true
end

# ################################################
# Upstart Script to Start Our Node App
# ################################################
template '/etc/init/hpf.conf' do
	source 'upstart/hpf.conf.erb'
	mode 0440
end

service 'hpf' do 
	action :start 
end