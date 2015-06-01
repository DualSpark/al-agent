# ------------
# ------------
# rsyslog - this forwards everything to port 1514 how to do this using RainerScript.
# facility.priority so *.* = everything
# @@ = tcp
# 127.0.0.1:1514 = forwarding everything to port 1514
# RSYSLOG_FileFormat; = using the default RSYSLOG_FileFormat

# echo "*.* @@127.0.0.1:1514;RSYSLOG_FileFormat" >> /etc/rsyslog.conf
# # return 0 in case of restart
# ps -e | grep -q rsyslog && service rsyslog restart || echo "rsyslog not running"

log 'log: rsyslog here'

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/alertlogic.conf" do
  source  'rsyslog/alertlogic.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  not_if { ::File.exists?("#{node['rsyslog']['config_prefix']}/rsyslog.d/alertlogic.conf") }
end

extend RsyslogCookbook::Helpers
declare_rsyslog_service

node.run_state['logging_by'] = 'rsyslog'
