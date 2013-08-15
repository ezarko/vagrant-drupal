include stdlib

class drupal7 (
  $docroot         = NULL,
  $global_themes   = [],
  $global_modules  = [],
  $default_themes  = [],
  $default_modules = [],
) {
  validate_string($docroot)

  package { git:
    ensure => present,
  }

  package {["gd","gd-devel","php-gd","php-mbstring","php-pdo","php-pgsql","php-xml"]:
    ensure => installed,
  }->
  file { "/etc/php.ini":
    source => "puppet:///modules/drupal7/php.ini",
    notify => Service['httpd'],
  }

  vcsrepo { $docroot:
    ensure => present,
    provider => git,
    source => 'git://git.drupal.org/project/drupal.git',
    revision => '7.22',
    force => true,
    owner => 'apache',
    group => 'apache',
  }->
  file { "$docroot/sites/default/files":
    ensure => 'directory',
    owner => 'apache',
    group => 'apache',
  }

#  define global_theme {
#    notify { "git submodule add git://git.drupal.org/project/$name sites/all/themes/$name":}
#  }
#  define global_module {
#    vcsrepo { "sites/all/modules/$title":
#      path => "$docroot/sites/all/modules/$title",
#      ensure => present,
#      provider => git,
#      module => true,
#      source => "git://git.drupal.org/project/$title.git",
#      force => true,
#      require => Vcsrepo[$docroot],
#    }
#  }
#  define default_theme {
#    notify { "git submodule add git://git.drupal.org/project/$name sites/default/themes/$name":}
#  }
#  define default_module {
#    notify { "git submodule add git://git.drupal.org/project/$name sites/default/modules/$name":}
#  }

  # if $global_themes and ! $global_themes.empty? {
  #   global_theme { $global_themes:; }
  # }
  # if $global_modules and ! $global_modules.empty? {
  #   global_module { $global_modules:; }
  # }
  # if $default_themes and ! $default_themes.empty? {
  #   default_theme { $default_themes:; }
  # }
  # if $default_modules and ! $default_modules.empty? {
  #   default_module { $default_modules:; }
  # }
#  global_module { 'ctools':; }
}
