include_recipe 'al_agent::selinux' if selinux_enabled?
include_recipe 'al_agent::rsyslog' if rsyslog_detected?
include_recipe 'al_agent::syslog_ng' if syslogng_detected?

include_recipe 'al_agent::install'
include_recipe 'al_agent::start' unless for_ami
include_recipe 'al_agent::test_log' unless for_ami
