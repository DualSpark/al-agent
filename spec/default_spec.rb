require 'spec_helper'

describe 'al_agent::default' do

  # before do
  #   allow_any_instance_of(Chef::Config).to receive(:file_cache_path)
  #     .and_return('/tmp')
  # end

  # before do
  #   Fauxhai.mock(platform: 'ubuntu', version: '12.04') do |node|
  #     node['al_agent']['package']['url'] = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
  #   end
  # end

  context 'debian family' do

    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '12.04'
      ).converge(described_recipe)
    }

    it 'downloads al-agent' do
      expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/al-agent_LATEST_amd64.deb")
    end

    it 'installs al-agent' do
      # expect(chef_run).to install_package("#{node['al_agent']['package']['url']}")
      expect(chef_run).to install_package("al-agent_LATEST_amd64.deb")
    end

    # configuration
    # /etc/init.d/al-agent configure --- do I test the result or that it executes?
    # how does
    it 'creates a controller_host file? || it executes the configure command' do
      # expect(chef_run).to render_file('/var/alertlogic/lib/agent/etc/controller_host')
      expect(chef_run).to run_execute('configure al-agent_LATEST_amd64.deb')
    end

    # provisioning
    it 'executes provisioning' do
      expect(chef_run).to run_execute('provision al-agent_LATEST_amd64.deb')
    end

    # agent startup
    it 'starts al-agent' do
      expect(chef_run).to start_service('al-agent')
      # .with(
      #   'service_name' => 'splunk'
      # )
    end
  end

  context 'rhel family' do
  end
end
