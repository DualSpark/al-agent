
# registration key is a must
default['al_agent']['agent']['registration_key'] = 'your_registration_key_here'

# for_autoscaling:
default['al_agent']['agent']['for_autoscaling'] = false

# for_imaging
default['al_agent']['agent']['for_imaging'] = false

# Route egress to a particular host:port. default is vaporator.alertlogic.com:443
default['al_agent']['agent']['egress_url'] = 'https://vaporator.alertlogic.com:443'

# packages
default['al_agent']['package']['name'] = 'al-agent'
case node['platform_family']
when 'rhel', 'fedora'
  default['al_agent']['package_type'] = Chef::Provider::Package::Rpm
  default['al_agent']['install_platform']  = '_linux'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.x86_64.rpm'
  else
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent-LATEST-1.i386.rpm'
  end
when 'debian'
  default['al_agent']['package_type'] = Chef::Provider::Package::Dpkg
  default['al_agent']['install_platform']  = '_linux'
  if node['kernel']['machine'] == 'x86_64'
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
  else
    default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb'
  end
when 'windows'
  default['al_agent']['package_type'] = Chef::Provider::Package::Windows
  default['al_agent']['install_platform']  = '_windows'
  default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.msi'
  # when to use the zip?
  # default['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al_agent-LATEST.zip'
end
