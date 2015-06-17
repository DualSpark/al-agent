cache_dir = Chef::Config[:file_cache_path]
basename = agent_file(node['al_agent']['package']['url'])
cached_package = ::File.join(cache_dir, basename)

remote_file basename do
  path cached_package
  source node['al_agent']['package']['url']
  action :create_if_missing
  notifies :install, "package[#{basename}]", :immediately
end

package basename do
  source cached_package
  action :nothing
  options windows_options
end
# reinstall causes an issue https://github.com/chef/chef/issues/3055s
