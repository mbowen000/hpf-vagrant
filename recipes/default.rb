#
# Cookbook Name:: hpf
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2'
include_recipe 'nodejs'
include_recipe 'git'

nodejs_npm 'sails'