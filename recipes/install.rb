#
# Cookbook Name:: al_agent
# Recipe:: install
#
# Copyright 2015, AlertLogic
#
# All rights reserved - Do Not Redistribute
#

cache_dir = Chef::Config[:file_cache_path]
basename = agent_file(node['al_agent']['package']['url'])
cached_package = ::File.join(cache_dir, basename)

remote_file basename do
  path cached_package
  source node['al_agent']['package']['url']
  action :create_if_missing
end

package basename do
  source cached_package
  action :install
  provider package_type
end

# TODO: the configure block does not have a guard because that controller_host always exists.
execute "configure #{basename}" do
  user 'root'
  cwd '/etc/init.d'
  command "./al-agent configure #{configure_options}"
  # not_if { ::File.exist?('/var/alertlogic/lib/agent/etc/controller_host') }
end

execute "provision #{basename}" do
  user 'root'
  cwd '/etc/init.d'
  command "./al-agent provision #{provision_options}"
  not_if { ::File.exist?('/var/alertlogic/etc/host_key.pem') }
end
