
# do these defaults make sense?
default['al_agent']['configure_only'] = false

# commenting out .. doing detection
# default['al_agent']['configure_selinux'] = true
# default['al_agent']['configure_iptable'] = true
# default['al_agent']['attempt_rsyslog_configure'] = false

# registration key is a must
default['al_agent']['agent']['registration_key'] = 'your_registration_key_here'
# valid options are host or role
default['al_agent']['agent']["inst_type"] = 'host'
# route egress to a particular host. leave empty for default
default['al_agent']['agent']['egress_host'] = ''
# iptables output chain policies
default['al_agent']['agent']['firewall'] = ['vaporator.alertlogic.com:443']

# packages
default['al_agent']['package']['name'] = 'al-agent'
case node['platform_family']
when 'rhel', 'fedora'
  # default['al_agent']['selinux']['package'] = 'policycoreutils-python'
  if node['kernel']['machine'] == 'x86_64'
    # 64-bit rhel
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.x86_64.rpm'
  else
    # 32-bit rhel
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.i386.rpm'
  end
when 'debian'
  # default['al_agent']['selinux']['package'] = 'policycoreutils'
  if node['kernel']['machine'] == 'x86_64'
    # 64-bit debian
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
  else
    # 32-bit debian
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb'
  end
when 'windows'
  default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.msi'
  # when to use the zip?
  # default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.zip'
end

# 32-bit debian
# https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb
# 64-bit debian
# https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb

# 32-bit rhel
# https://scc.alertlogic.net/software/al-agent-LATEST-1.i386.rpm
# 64-bit rhel
# https://scc.alertlogic.net/software/al-agent-LATEST-1.x86_64.rpm

# windows msi
# https://scc.alertlogic.net/software/al_agent-LATEST.msi
# windows zip
# https://scc.alertlogic.net/software/al_agent-LATEST.zip
