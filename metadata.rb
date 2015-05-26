name             'al_agent'
maintainer       'DualSpark'
maintainer_email 'john.ramos'
license          'All rights reserved'
description      'Installs/Configures the Alert Logic Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'selinux_policy'
depends 'iptables'
depends 'rsyslog'
depends 'syslog-ng'
