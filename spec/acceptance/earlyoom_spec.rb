require 'spec_helper_acceptance'

describe 'earlyoom' do
  context 'with earlyoom' do
    let(:pp) do
      '
        if $facts["os"]["family"] == "RedHat" {
          package{"epel-release":
            ensure => present,
            before => Class["earlyoom"]
          }
        }
        contain "earlyoom"
      '
    end

    it 'configures and work with no errors' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    describe file('/etc/default/earlyoom') do
      its(:content) { is_expected.to match %r{^EARLYOOM_ARGS="-r 60"$} }
    end
    describe service('earlyoom') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
