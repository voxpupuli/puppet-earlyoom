# @summary Installs earlyoom and configures earlyoom
#
# @see https://github.com/rfjakob/earlyoom earlyoom homepage
#
# @example Simple Example
#  class{'earlyoom':}
#
# @example Full Example
#  class{'earlyoom':
#    interval        => 120,
#    ignore_positive => true,
#    notify_send     => true,
#    debug           => true,
#    priority        => true,
#    prefer          => '(^|/)(init|X|sshd|firefox)$',
#    avoid           => '(^|/)(cupsd|xrootd)$',
#    notify_command  => '/bin/echo ${UID}',
#    memory_percent  => 20,
#    swap_percent    => [10,4]
#    memory_size     => 20000,
#    swap_size       => [30000,60000],
#    dryrun          => false,
#  }
#
# @param pkgname
#  Name of package to install
#
# @param interval
#  Memory report interval in seconds
#
# @param configfile
#  Full filename of configuration file
#
# @param service_enable
#  Should the earlyoom service be started.
#
# @param ignore_positive
#  If true user-space oom killer should ignore positive oom_score_adj values (-i)
#
# @param notify_send
#  If true enable notifications using "notify-send" (-n)
#
# @param debug
#  If true enable debug messages (-d)
#
# @param notify_command
#  Specify a command to enable notifications with. (-N cmd)
#
# @param priority
#  If true set niceness of earlyoom to -20 and oom_score_adj to -1000 (-p)
#
# @param avoid
#  avoid killing processes matching REGEX (--avoid REGEX)
#
# @param prefer
#  avoid killing processes matching REGEX (--prefer REGEX)
#
# @param memory_percent
#     set available memory minimum to PERCENT of total
#     earlyoom sends SIGTERM once below PERCENT, then
#     SIGKILL once below KILL_PERCENT (default PERCENT/2).
#     (-m int or -m int,int
#
# @param swap_percent
#     set available swap minimum to PERCENT of total
#     earlyoom sends SIGTERM once below PERCENT, then
#     SIGKILL once below KILL_PERCENT (default PERCENT/2).
#     (-s int or -s int,int
#
# @param memory_size
#     set available memory minimum to SIZE Kib
#     earlyoom sends SIGTERM once below PERCENT, then
#     SIGKILL once below KILL_PERCENT (default PERCENT/2).
#     (-M int or -M int,int
#
# @param swap_size
#     set available memory minimum to SIZE Kib
#     earlyoom sends SIGTERM once below PERCENT, then
#     SIGKILL once below KILL_PERCENT (default PERCENT/2).
#     (-S int or -S int,int
#
# @param dryrun
#     if true dry run (do not kill any processes) (--dryrun)
#
# @param local_user
#     On the RedHat family of OSes the earlyoom service uses a systemd dynamic user in
#     its service unit. Setting this to true will create a local system account "earlyoom"
#     to run earlyoom as instead.
#     On the Debian family earlyoom runs as root and this parameter is ignored.
#     Note to transition from `false` to `true` it may be necessary to stop earlyoom
#     so the dynamic user is not present and the local user can be added.
#
class earlyoom (
  String[1] $pkgname                  = 'earlyoom',
  Stdlib::Unixpath $configfile        = '/etc/default/earlyoom',
  Integer[0] $interval                = 60,
  Boolean $service_enable             = true,
  Boolean $ignore_positive            = false,
  Boolean $notify_send                = false,
  Boolean $debug                      = false,
  Boolean $priority                   = false,
  Boolean $dryrun                     = false,
  Boolean $local_user                 = false,
  Optional[String[1]] $prefer         = undef,
  Optional[String[1]] $avoid          = undef,
  Optional[String[1]] $notify_command = undef,
  Optional[Variant[Integer[0,100],Array[Integer[0,100],2,2]]] $memory_percent = undef,
  Optional[Variant[Integer[0,100],Array[Integer[0,100],2,2]]] $swap_percent   = undef,
  Optional[Variant[Integer[0],Array[Integer[0],2,2]]]         $memory_size    = undef,
  Optional[Variant[Integer[0],Array[Integer[0],2,2]]]         $swap_size      = undef,

) {
  contain 'earlyoom::install'
  contain 'earlyoom::config'
  contain 'earlyoom::service'

  Class['earlyoom::install']
  -> Class['earlyoom::config']
  ~> Class['earlyoom::service']
}
