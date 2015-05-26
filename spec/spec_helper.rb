require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'

ChefSpec::Coverage.start! do
  add_filter do |resource|
    resource.name =~ /log:/
  end
end

LOG_LEVEL = :debug
REDHAT_OPTS = {
  :platform => 'redhat',
  :version => '6.5',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}
UBUNTU_OPTS = {
  :platform => 'ubuntu',
  :version => '14.04',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}
CENTOS_OPTS = {
  :platform => 'centos',
  :version => '7.0',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}

shared_context 'stubs' do
  before do
    allow_any_instance_of(Chef::Config).to receive(:file_cache_path)
      .and_return('/tmp')
  end
end
