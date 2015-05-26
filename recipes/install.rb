#
# Cookbook Name:: al_agent
# Recipe:: install
#
# Copyright 2015, AlertLogic
#
# All rights reserved - Do Not Redistribute
#

# ------------
# agent_install
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
  case node['platform_family']
  when 'rhel'
    provider Chef::Provider::Package::Rpm
  when 'debian'
    provider Chef::Provider::Package::Dpkg
  when 'windows'
    provider Chef::Provider::Package::Windows
  end
end

# --------------------
log 'log: starting configuration'

egress_host = node['al_agent']['agent']['egress_host']

execute "configure #{basename}" do
  user "root"
  cwd "/etc/init.d"
  command "./al-agent configure"
  not_if { ::File.exists?("/var/alertlogic/lib/agent/etc/controller_host") }
end

# bash "#{basename} configure" do
#   user "root"
#   code "/etc/init.d/al-agent configure"
# end
log 'log: end configuration'

# --------------------
log 'log: starting provision'
execute "provision #{basename}" do
  user "root"
  cwd "/etc/init.d"
  command "./al-agent provision --key #{node['al_agent']['agent']['registration_key']}"
  not_if { ::File.exists?("/var/alertlogic/etc/host_key.pem") }
end
log 'log: end provision'


## -------------------
log 'log: start service'
service 'al-agent' do
  action :start
end
log 'log: end service'
