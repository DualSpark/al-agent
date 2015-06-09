require 'spec_helper'

describe 'al_agent::windows' do

  let(:chef_run) {
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
  }

  context 'windows family' do

    # it 'calls the methods for sensor host and senor port' do
    #   expect(chef_run).to receive(:sensor_host)
    # end

    # https://github.com/sethvargo/chefspec/issues/401
    it 'covering remote_file' do
      download = chef_run.remote_file('al_agent-LATEST.msi')
      expect(download).to notify('windows_package[al_agent-LATEST.msi]').to(:install)
    end

    it 'installs the windows package' do
      expect(chef_run).to install_package 'al_agent-LATEST.msi'
    end

  end
end
