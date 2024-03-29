# require 'spec_helper'
require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'grafana' do

  let(:title) { 'grafana' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { {
    :ipaddress => '10.42.42.42',
  } }

  describe 'Test default settings  ' do
    it 'should install grafana package' do should contain_package('grafana').with_ensure('present') end
    it 'should run grafana service' do should contain_service('grafana').with_ensure('running') end
    it 'should enable grafana service at boot' do should contain_service('grafana').with_enable('true') end
    it 'should manage config file presence' do should contain_file('grafana.conf').with_ensure('present') end
  end

  describe 'Test installation of a specific package version' do
    let(:params) { {
      :install => 'package',
      :version => '1.0.42',
    } }
    it { should contain_package('grafana').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning of package installation' do
    let(:params) { {
      :ensure => 'absent',
      :install => 'package',
    } }
    it 'should remove Package[grafana]' do should contain_package('grafana').with_ensure('absent') end
    it 'should stop Service[grafana]' do should contain_service('grafana').with_ensure('stopped') end
    it 'should not manage at boot Service[grafana]' do should contain_service('grafana').with_enable(nil) end
    it 'should remove grafana configuration file' do should contain_file('grafana.conf').with_ensure('absent') end
  end

  describe 'Test service disabling' do
    let(:params) { {
      :service_ensure => 'stopped',
      :service_enable => false,
    } }
    it 'should stop Service[grafana]' do should contain_service('grafana').with_ensure('stopped') end
    it 'should not enable at boot Service[grafana]' do should contain_service('grafana').with_enable('false') end
  end

  describe 'Test custom file via template' do
    let(:params) { {
      :file_template => 'grafana/spec/spec.conf.erb',
      :file_options_hash => { 'opt_a' => 'value_a' },
    } }
    it { should contain_file('grafana.conf').with_content(/fqdn: rspec.example42.com/) }
    it 'should generate a template that uses custom options' do
      should contain_file('grafana.conf').with_content(/value_a/)
    end
  end

  describe 'Test custom file via source' do
    let(:params) { {:file_source => "puppet:///modules/grafana/spec/spec.conf"} }
    it { should contain_file('grafana.conf').with_source('puppet:///modules/grafana/spec/spec.conf') }
  end

  describe 'Test customizations - dir' do
    let(:params) { {
      :dir_source => 'puppet:///modules/grafana/tests/',
      :dir_purge => true
    } }
    it { should contain_file('grafana.dir').with_source('puppet:///modules/grafana/tests/') }
    it { should contain_file('grafana.dir').with_purge('true') }
    it { should contain_file('grafana.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "grafana::spec" } }
    it { should contain_file('my_config').with_content(/my_content/) }
    it { should contain_file('my_config').with_path('/etc/grafana/my_config') }
  end

  describe 'Test service subscribe' do
    let(:params) { {:service_subscribe => false } }
    it 'should not automatically restart the service when files change' do
      should contain_service('grafana').with_subscribe(false)
    end
  end

end
