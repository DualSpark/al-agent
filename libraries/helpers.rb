# bring in the selinux_enabled? method
Chef::Recipe.send(:include, Chef::Util::Selinux)

def al_agent
  node['al_agent']['package']['name']
end

def agent_file(uri)
  require 'pathname'
  require 'uri'
  Pathname.new(URI.parse(uri).path).basename.to_s
end

def rsyslog_detected?
  file_path = "#{node['rsyslog']['config_prefix']}/rsyslog.conf"
  status = ::File.exists?("#{file_path}")
  log "rsyslog_detected? #{file_path} found? #{status}"
  status
end

def syslogng_detected?
  status = ::File.exists?("/etc/syslog-ng/syslog-ng.conf")
  log "syslogng_detected? #{status}"
  status
end

def iptables_detected?
  true
end

def configuration_options
  options = []
  options << "--host #{node['al_agent']['agent']['egress_host']}" if node['al_agent']['agent']['egress_host']
  options.join(" ")
end

def provisioning_options
  options = []
  options << "--inst_type #{node['al_agent']['agent']['inst_type']}" if node['al_agent']['agent']['inst_type']
  options.join(" ")
end
