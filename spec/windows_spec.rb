require 'spec_helper'

describe 'al_agent::_windows' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
  end
  let(:package_name) { 'al_agent-LATEST.msi' }
  let(:remote_file) { "#{Chef::Config[:file_cache_path]}/#{package_name}" }

  context 'windows family' do
    before do
      stub_command("C:\\Program Files (x86)\\Common Files\\AlertLogic\\prov_key.pem").and_return(false)
    end

    it 'downloads the file' do
      expect(chef_run).to create_remote_file_if_missing("#{remote_file}")
    end

    # https://github.com/sethvargo/chefspec/issues/401
    it 'notifies the package to install' do
      download = chef_run.remote_file('al_agent-LATEST.msi')
      expect(download).to notify('windows_package[al_agent-LATEST.msi]').to(:install)
    end

    # TODO: test on a windows platform
    # it 'installs the windows package' do
    #   expect(chef_run).to install_package('al_agent-LATEST.msi')
    # end

    context 'with a specified egress_url' do
      # context 'that doesn\'t have a scheme' do
      #   let(:chef_run) do
      #     ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
      #       node.set['al_agent']['agent']['egress_url'] = 'vaporator.alertlogic.com:443'
      #     end.converge(described_recipe)
      #   end
      #
      #   it 'should run' do
      #     expect(chef_run).to install_package('al_agent-LATEST.msi')
      #   end
      # end

      context 'that has an invalid egress_url' do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
            node.set['al_agent']['agent']['egress_url'] = 'bad_string'
          end.converge(described_recipe)
        end

        it 'should return an error' do
          expect { chef_run }.to raise_error
        end
      end
    end
  end
end
