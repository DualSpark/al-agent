require 'spec_helper'

describe 'al_agent::syslog_ng' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '12.04'
    ).converge(described_recipe)
  }
  let(:alertlogic_conf_file) { '/etc/syslog-ng/conf.d/alertlogic.conf' }

  it 'creates an alertlogic.conf file' do
    expect(chef_run).to render_file(alertlogic_conf_file)
  end

  it 'notifies the syslog_ng service to restart' do
    template = chef_run.template(alertlogic_conf_file)
    expect(template).to notify('service[syslog-ng]').to(:restart)
  end

  it 'starts the service' do
    expect(chef_run).to start_service('syslog-ng')
  end

end
