
# before do
#   Manipulator.stub(:new).and_return(manipulator)
#   Manipulator.should_receive(:new).with(kind_of(Chef::Node))
#     .and_return(manipulator)
#   manipulator.should_receive(:save!)
# end


require 'spec_helper'

describe 'al_agent::default' do

  # before do
  #   allow_any_instance_of(Chef::Config).to receive(:file_cache_path)
  #     .and_return('/tmp')
  # end


  context 'with ubuntu' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '12.04'
      ).converge(described_recipe)
    }
    let(:package_name) { 'al-agent_LATEST_amd64.deb' }
    let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

    it 'downloads al-agent' do
      expect(chef_run).to create_remote_file_if_missing("#{remote_file}")
    end

    it 'installs al-agent' do
      expect(chef_run).to install_package("#{package_name}")
    end

    it 'creates a controller_host file? || it executes the configure command' do
      # expect(chef_run).to render_file('/var/alertlogic/lib/agent/etc/controller_host')
      expect(chef_run).to run_execute("configure #{package_name}")
    end

    it 'executes provisioning' do
      expect(chef_run).to run_execute("provision #{package_name}")
    end

    it 'starts al-agent' do
      expect(chef_run).to start_service('al-agent')
    end

    # TODO: how do I handle a helper method!!

    it 'logs data' do
      expect(chef_run).to run_execute('logging')
    end
  end

  context 'with debian' do
    let(:chef_run) {
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.6'
      ).converge(described_recipe)
    }
    let(:package_name) { 'al-agent-LATEST-1.x86_64.rpm' }
    let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

    it 'downloads al-agent' do
      expect(chef_run).to create_remote_file_if_missing("#{remote_file}")
    end

    it 'installs al-agent' do
      expect(chef_run).to install_package("#{package_name}")
    end

    it 'creates a controller_host file? || it executes the configure command' do
      # expect(chef_run).to render_file('/var/alertlogic/lib/agent/etc/controller_host')
      expect(chef_run).to run_execute("configure #{package_name}")
    end

    it 'executes provisioning' do
      expect(chef_run).to run_execute("provision #{package_name}")
    end

    context 'for_imaging' do
      let(:chef_run) {
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          version: '6.6'
        ) do |node|
          node.set['al_agent']['for_ami'] = true
        end.converge(described_recipe)
      }

      # it 'does not start the service' do
      #   expect(chef_run).to_not start_service('al-agent')
      # end
    end
  end

end
