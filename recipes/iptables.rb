# ------------
# ------------
# ip table setup - see https://github.com/opscode-cookbooks/iptables
# node["alertlogic"]["agent"]["firewall"].each do |i|
#   iptables -A OUTPUT -m tcp -p tcp -d #{fw_net}--dport #{fw_port} -j ACCEPT"
# end

log 'log: start iptable management'

include_recipe 'iptables::default'
iptables_rule 'outbound_chain' do
  action :enable
end

log 'log: end iptable management'
