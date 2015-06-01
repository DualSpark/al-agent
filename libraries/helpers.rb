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

# TODO: detect iptables - do we want to do this, was it only for internal testing?
def iptables_detected?
  true
end

def registration_key
  node['al_agent']['agent']['registration_key']
end

# for_autoscaling: role ~> autoscaling = true, host ~> autoscaling = false
def for_autoscaling
  node['al_agent']['agent']['for_autoscaling']
end

# for_ami: configure ~> run just the configure commands, provision ~> run the provision command
def for_ami
  node['al_agent']['agent']['for_ami']
end

def egress_host
  node['al_agent']['agent']['egress_host']
end

def egress_host_exists?
  egress_host.size > 0
end

def inst_type_value
  if for_ami
    'role'
  else
    'host'
  end
end

def configure_options
  options = []
  options << "--host #{egress_host}" if egress_host_exists?
  options.join(" ")
end

def provision_options
  options = []
  options << "--key #{registration_key}"
  options << "--inst-type #{inst_type_value}"
  options.join(" ")
end
