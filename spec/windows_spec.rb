require 'spec_helper'

describe 'al_agent::windows' do

  let(:chef_run) {
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
  }
  let(:package_name) { 'al_agent-LATEST.msi' }
  let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

  context 'windows family' do
    it 'downloads the file' do
      expect(chef_run).to create_remote_file_if_missing("#{remote_file}")
    end

    # https://github.com/sethvargo/chefspec/issues/401
    it 'notifies the package to install' do
      download = chef_run.remote_file('al_agent-LATEST.msi')
      expect(download).to notify('windows_package[al_agent-LATEST.msi]').to(:install)
    end

    # does not work on linux. TODO: test on a windows platform
    # it 'installs the windows package' do
    #   expect(chef_run).to install_package('al_agent-LATEST.msi')
    # end

    # it 'calls the methods for sensor host and senor port' do
    #   expect(chef_run).to receive(:sensor_host)
    # end
  end
end
