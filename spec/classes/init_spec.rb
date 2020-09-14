require 'spec_helper'
describe 'earlyoom', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('earlyoom') }
        it { is_expected.to contain_class('earlyoom::install') }
        it { is_expected.to contain_class('earlyoom::config') }
        it { is_expected.to contain_class('earlyoom::service') }
        it { is_expected.to contain_package('earlyoom') }
        it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60"$}) }
        it { is_expected.to contain_service('earlyoom').with_ensure(true) }
        it { is_expected.to contain_service('earlyoom').with_enable(true) }
        context 'with interval specified' do
          let(:params) do
            { interval: 123 }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 123"$}) }
        end
        context 'with ignore_positive specified' do
          let(:params) do
            { ignore_positive: true }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -i"$}) }
        end
        context 'with debug specified' do
          let(:params) do
            { debug: true }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -d"$}) }
        end
        context 'with priority specified' do
          let(:params) do
            { priority: true }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -p"$}) }
        end

        context 'with notify_send specified' do
          let(:params) do
            { notify_send: true }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -n"$}) }
        end

        context 'with notify_command specified' do
          let(:params) do
            { notify_command: '/foo/bar' }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -N '/foo/bar'"$}) }
        end

        context 'with prefer specified' do
          let(:params) do
            { prefer: '^(sshd|firefox)$' }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 --prefer '\^\(sshd\|firefox\)\$'"$}) }
        end

        context 'with avoid specified' do
          let(:params) do
            { avoid: '^(foo|bar)$' }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 --avoid '\^\(foo\|bar\)\$'"$}) }
        end

        context 'with dryrun specified false' do
          let(:params) do
            { dryrun: false }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60"$}) }
        end

        context 'with dryrun specified true' do
          let(:params) do
            { dryrun: true }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 --dryrun"$}) }
        end

        context 'with memory_percent TERM only specified' do
          let(:params) do
            { memory_percent: 85 }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -m 85"$}) }
        end

        context 'with memory_percent TERM and KILL specified' do
          let(:params) do
            { memory_percent: [85, 90] }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -m 85,90"$}) }
        end

        context 'with swap_percent TERM only specified' do
          let(:params) do
            { swap_percent: 9 }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -s 9"$}) }
        end

        context 'with swap_percent TERM and KILL specified' do
          let(:params) do
            { swap_percent: [12, 15] }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -s 12,15"$}) }
        end

        context 'with memory_size TERM only specified' do
          let(:params) do
            { memory_size: 85 }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -M 85"$}) }
        end

        context 'with memory_size TERM and KILL specified' do
          let(:params) do
            { memory_size: [85, 90] }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -M 85,90"$}) }
        end

        context 'with swap_size TERM only specified' do
          let(:params) do
            { swap_size: 9 }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -S 9"$}) }
        end

        context 'with swap_size TERM and KILL specified' do
          let(:params) do
            { swap_size: [12, 15] }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 60 -S 12,15"$}) }
        end
        context 'with every cmdline paramter specified' do
          let(:params) do
            {
              interval: 123,
              ignore_positive: true,
              debug: true,
              priority: true,
              notify_send: true,
              notify_command: '/foo/bar',
              prefer: 'alpha',
              avoid: 'beta',
              memory_percent: 22,
              swap_percent: [12, 14],
              memory_size: [4, 5],
              swap_size: 8,
              dryrun: true
            }
          end

          it { is_expected.to contain_file('/etc/default/earlyoom').with_content(%r{^EARLYOOM_ARGS="-r 123 -i -n -d -p --prefer 'alpha' --avoid 'beta' -N '\/foo\/bar' -m 22 -s 12,14 -M 4,5 -S 8 --dryrun"$}) }
        end
        context 'with pkgname specified' do
          let(:params) do
            { pkgname: 'trump' }
          end

          it { is_expected.to contain_package('trump') }
          it { is_expected.not_to contain_package('earlyoom') }
        end

        context 'with service_enable false' do
          let(:params) do
            { service_enable: false }
          end

          it { is_expected.to contain_service('earlyoom').with_enable(false) }
          it { is_expected.to contain_service('earlyoom').with_ensure(false) }
        end
      end
    end
  end
end
