include stdlib

class drupal7 (
  $docroot         = undef,

  $profile         = undef,
  $account_mail    = undef,
  $account_name    = undef,
  $account_pass    = undef,
  $clean_url       = undef,
  $db_prefix       = undef,
  $db_su           = undef,
  $db_su_pw        = undef,
  $db_url          = undef,
  $locale          = undef,
  $site_mail       = undef,
  $site_name       = undef,
  $sites_subdir    = undef,

  $global_themes   = [],
  $global_modules  = [],
  $default_themes  = [],
  $default_modules = [],
) {
  validate_string($docroot)

  validate_string($profile)
  validate_string($account_mail)
  validate_string($account_name)
  validate_string($account_pass)
  validate_string($clean_url)
  validate_string($db_prefix)
  validate_string($db_su)
  validate_string($db_su_pw)
  validate_string($db_username)
  validate_string($db_password)
  validate_string($db_database)
  validate_string($locale)
  validate_string($site_mail)
  validate_string($site_name)
  validate_string($sites_subdir)

  require php

  vcsrepo { '/usr/local/drush':
    ensure => present,
    provider => git,
    source => 'https://github.com/drush-ops/drush.git',
  }->
  file { '/usr/local/drush/drush':
    mode => 0755,
  }->
  file { '/usr/bin/drush':
    mode => 0755,
    ensure => link,
    target => '/usr/local/drush/drush',
  }

  $install_options = inline_template("<% if @profile %> <%= profile %><% end %><% if @account_mail %> --account-mail=<%= account_mail %><% end %><% if @account_name %> --account-name=<%= account_name %><% end %><% if @account_pass %> --account-pass=<%= account_pass %><% end %><% if @clean_url %> --clean-url=<%= clean_url %><% end %><% if @db_prefix %> --db-prefix=<%= db_prefix %><% end %><% if @db_su %> --db-su=<%= db_su %><% end %><% if @db_su_pw %> --db-su-pw=<%= db_su_pw %><% end %><% if @db_url %> --db-url=<%= db_url %><% end %><% if @locale %> --locale=<%= locale %><% end %><% if @site_mail %> --site-mail=<%= site_mail %><% end %><% if @site_name %> --site-name=<%= site_name %><% end %><% if @sites_subdir %> --sites-subdir=<%= sites_subdir %><% end %>")

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
  }->
  exec {'drush-site-install':
    environment => "PGPASSWORD=${::randompass}", # HACK: how to get PostgreSQL to behave?
    command     => "drush --root=${docroot} --yes site-install ${install_options}",
    creates     => "${docroot}/sites/default/settings.php",
    require     => File['/usr/bin/drush'],
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
