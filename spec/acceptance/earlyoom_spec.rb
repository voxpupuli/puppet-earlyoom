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
    describe file('/etc/passwd') do
      its(:content) { is_expected.not_to match %r{^earlyoom:.*} }
    end
    if fact('os.family') == 'RedHat'
      describe process('earlyoom') do
        its(:user) { is_expected.to eq 'earlyoom' }
      end
    else
      describe process('earlyoom') do
        its(:user) { is_expected.to eq 'root' }
      end
    end
  end
  context 'with service_enable false' do
    let(:pp) do
      '
        if $facts["os"]["family"] == "RedHat" {
          package{"epel-release":
            ensure => present,
            before => Class["earlyoom"]
          }
        }
        class{"earlyoom":
          service_enable => false,
        }
      '
    end

    it 'configures and work with no errors' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    describe service('earlyoom') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
  context 'with earlyoom and local_user true' do
    let(:pp) do
      '
        if $facts["os"]["family"] == "RedHat" {
          package{"epel-release":
            ensure => present,
            before => Class["earlyoom"]
          }
        }
        class{"earlyoom":
          local_user => true
        }
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

    if fact('os.family') == 'RedHat'
      describe file('/etc/passwd') do
        its(:content) { is_expected.to match %r{^earlyoom:.*} }
      end
      describe process('earlyoom') do
        its(:user) { is_expected.to eq 'earlyoom' }
      end
    else
      describe file('/etc/passwd') do
        its(:content) { is_expected.not_to match %r{^earlyoom:.*} }
      end
      describe process('earlyoom') do
        its(:user) { is_expected.to eq 'root' }
      end
      describe user('earlyoom') do
        it { is_expected.not_to exist }
      end
    end
  end
end
