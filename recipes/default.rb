#
# Cookbook Name:: al_agent
# Recipe:: default
#
# Copyright 2015, AlertLogic
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'al_agent::selinux' if selinux_enabled?
include_recipe 'al_agent::iptables' if iptables_detected?
include_recipe 'al_agent::rsyslog' if rsyslog_detected?
include_recipe 'al_agent::syslogng' if syslogng_detected?

include_recipe 'al_agent::install'
include_recipe 'al_agent::start' unless for_ami
include_recipe 'al_agent::test_log' unless for_ami
