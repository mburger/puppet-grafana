require 'spec_helper_system'

describe 'install:' do
  after :all do
    # Cleanup after tests have ran
#    puppet_apply("class { 'grafana': ensure => absent }") do |r|
#      r.exit_code.should_not == 1
#    end
  end

  it 'test default installation' do
    pp = fixture_read('modules/grafana/tests/init.pp')

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end

    puppet_apply(pp) do |r|
      r.exit_code.should be_zero
    end
  end

  it 'test upstream installation' do
    pp = fixture_read('modules/grafana/tests/upstream.pp')

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end

    puppet_apply(pp) do |r|
      r.exit_code.should be_zero
    end
  end

end
