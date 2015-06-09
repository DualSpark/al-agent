template '/etc/syslog-ng/conf.d/alertlogic.conf' do
  source 'syslogng/alertlogic.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[syslog-ng]"
  not_if { ::File.exists?("/etc/syslog-ng/conf.d/alertlogic.conf") }
end

service 'syslog-ng' do
  action [:enable, :start]
end

node.run_state['logging_by'] = 'syslog-ng'
