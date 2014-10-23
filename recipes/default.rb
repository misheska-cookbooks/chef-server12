#
# Cookbook Name:: chef-server12
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

# include helper methods
::Chef::Recipe.send(:include, PackageCloud::Helper)

include_recipe 'chef-server12::standalone_server'
include_recipe 'chef-server12::create_admin'
include_recipe 'chef-server12::create_org'
