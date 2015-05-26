#
# Cookbook Name:: al_agent
# Recipe:: selinux
#
# Copyright 2015, AlertLogic
#
# All rights reserved - Do Not Redistribute
#

# semanage port -a -t syslogd_port_t -p tcp 1514
# allow syslogd to listen on port 1514

log 'log: start selinux policy management'

include_recipe 'selinux_policy::install'
selinux_policy_port '1514' do
    protocol 'tcp'
    secontext 'syslogd_port_t'
end

log 'log: end selinux policy management'
