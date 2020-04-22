# Puppet Module for EarlyOOM

[![Build Status](https://travis-ci.org/voxpupuli/puppet-earlyoom.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-earlyoom)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-earlyoom/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-earlyoom)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/earlyoom.svg)](https://forge.puppetlabs.com/puppet/earlyoom)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/earlyoom.svg)](https://forge.puppetlabs.com/puppet/earlyoom)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/earlyoom.svg)](https://forge.puppetlabs.com/puppet/earlyoom)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/earlyoom.svg)](https://forge.puppetlabs.com/puppet/earlyoom)

This puppet module:

* Installs earlyoom package
* Configures `/etc/default/earlyoom`
* Controls the service `earlyoom`

The Early OOM Daemon checks the amount of available memory and free swap up to 10
times a second (less often if there is a lot of free memory).
By default if both are below 10%, it will kill the largest process (highest oom\_score).
The percentage value is configurable via command line arguments.

<https://github.com/rfjakob/earlyoom>

## Examples

```puppet
class{'earlyoom':}
```

```puppet
class{'earlyoom':
  interval        => 120,
  ignore_positive => true,
  notify_send     => true,
  debug           => true,
  priority        => true,
  prefer          => '(^|/)(init|X|sshd|firefox)$',
  avoid           => '(^|/)(cupsd|xrootd)$',
  notify_command  => '/bin/echo ${UID}',
  memory_percent  => 20,
  swap_percent    => [10,4]
  memory_size     => 20000,
  swap_size       => [30000,60000]
}
```

## Documentation

See [REFERENCE.md](REFERENCE.md)

## License

Apache-2.0

## Copyright

Steve Traylen, steve.traylen@cern.ch, CERN, 2020.

## Contact

Steve Traylen steve.traylen@cern.ch

## Support

Please log tickets and issues at <https://github.com/voxpupuli/puppet-earlyoom/issues>
