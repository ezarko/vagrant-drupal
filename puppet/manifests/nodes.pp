Exec { path => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin" }

node default {
  require baseline
  if $features =~ /(drupal7)/ {
    include centos_fw
    firewall { '100 allow http access':
      port   => [80],
      proto  => tcp,
      action => accept,
    }
    class { 'apache':
      mpm_module => "prefork",
    }
    class{ 'apache::mod::php':
    }
    include postgresql::server
    postgresql::db { 'drupal':
      user     => 'drupal',
      password => $::randompass,
    }
    class{ 'drupal7':
      docroot        => '/var/www/html',

      account_mail   => 'eric@zarko.org',
      account_name   => 'Eric',
      account_pass   => 'foobar',
      db_url         => "pgsql://drupal:${::randompass}@localhost/drupal",
      site_mail      => 'eric@zarko.org',
      site_name      => 'Drupal-Test',

      global_modules => ['ctools'],
      #require => Class['apache'],
    }
  }
}
