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

def service_name
  node['al_agent']['agent']['service_name']
end

def package_type
  node['al_agent']['package_type']
end

def windows_install_guard
  node['al_agent']['windows_install_guard']
end

def rsyslog_detected?
  file_path = "#{node['rsyslog']['config_prefix']}/rsyslog.conf"
  ::File.exist?(file_path)
end

def syslogng_detected?
  ::File.exist?('/etc/syslog-ng/syslog-ng.conf')
end

def registration_key
  node['al_agent']['agent']['registration_key']
end

# for_autoscaling: role ~> autoscaling = true, host ~> autoscaling = false
def for_autoscaling
  node['al_agent']['agent']['for_autoscaling']
end

# for_imaging: configure ~> run just the configure commands, provision ~> run the provision command
def for_imaging
  node['al_agent']['agent']['for_imaging']
end

def inst_type_value
  if for_autoscaling
    'role'
  else
    'host'
  end
end

def configure_options
  egress = Chef::Recipe::Egress.new(node)
  puts "*************** --host #{egress.host} ***************"
  options = []
  options << "--host #{egress.host}:#{egress.port}"
  options.join(' ')
end

def provision_options
  options = []
  options << "--key #{registration_key}"
  options << "--inst-type #{inst_type_value}"
  options.join(' ')
end

def windows_options
  egress = Chef::Recipe::Egress.new(node)
  windows_options = ["/quiet prov_key=#{registration_key}"]
  windows_options << "prov_only=#{inst_type_value}"
  windows_options << 'install_only=1' if for_imaging
  windows_options << "sensor_host=#{egress.sensor_host}"
  windows_options << "sensor_port=#{egress.sensor_port}"
  windows_options.join(' ')
end
