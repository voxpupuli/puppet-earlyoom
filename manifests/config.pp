# @summary  Configures earlyoom
#
# @api private
#
class earlyoom::config (
  $configfile      = $earlyoom::configfile,
  $interval        = $earlyoom::interval,
  $ignore_positive = $earlyoom::ignore_positive,
  $notify_send     = $earlyoom::notify_send,
  $debug           = $earlyoom::debug,
  $priority        = $earlyoom::priority,
  $prefer          = $earlyoom::prefer,
  $avoid           = $earlyoom::avoid,
  $notify_command  = $earlyoom::notify_command,
  $memory_percent  = $earlyoom::memory_percent,
  $swap_percent    = $earlyoom::swap_percent,
  $memory_size     = $earlyoom::memory_size,
  $swap_size       = $earlyoom::swap_size,
) {

  assert_private()

  # Build easyoom options. I wish push existed...

  $_interval = "-r ${interval}"

  $_ignore_positive = $ignore_positive ? {
    true    => '-i',
    default => '',
  }

  $_notify_send = $notify_send ? {
    true    => '-n',
    default => '',
  }

  $_debug = $debug ? {
    true    => '-d',
    default => '',
  }

  $_priority = $priority ? {
    true    => '-p',
    default => '',
  }

  $_prefer = $prefer ? {
    String => "--prefer '${prefer}'",
    default   => '',
  }

  $_avoid = $avoid ? {
    String => "--avoid '${avoid}'",
    default   => '',
  }

  $_notify_command = $notify_command ? {
    String => "-N '${notify_command}'",
    default   => '',
  }

  $_memory_percent = $memory_percent ? {
    Array   => "-m ${join($memory_percent,',')}",
    Integer => "-m ${memory_percent}",
    default => '',
  }

  $_swap_percent = $swap_percent ? {
    Array   => "-s ${join($swap_percent,',')}",
    Integer => "-s ${swap_percent}",
    default => '',
  }

  $_memory_size = $memory_size ? {
    Array   => "-M ${join($memory_size,',')}",
    Integer => "-M ${memory_size}",
    default => '',
  }

  $_swap_size = $swap_size ? {
    Array   => "-S ${join($swap_size,',')}",
    Integer => "-S ${swap_size}",
    default => '',
  }

  $_options = [
    $_interval,
    $_ignore_positive,
    $_notify_send,
    $_debug,
    $_priority,
    $_prefer,
    $_avoid,
    $_notify_command,
    $_memory_percent,
    $_swap_percent,
    $_memory_size,
    $_swap_size,
  ]

  file{$configfile:
    ensure       => present,
    content      => epp('earlyoom/default.epp',{
      'options' => $_options.delete('').join(' ')
    }),
    mode         => '0644',
    owner        => root,
    group        => root,
    validate_cmd => '/usr/bin/bash -n %',
  }
}
