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
    postgresql::db { 'mydatabasename':
      user     => 'mydatabaseuser',
      password => $randompass,
    }
    class{ 'drupal7':
      docroot        => '/var/www/html',
      global_modules => ['ctools'],
      #profile => standard
      #language => english
      #database

      #site name
      #site email address
      #username
      #email address
      #password
      #default country
      #default time zone
      #check for updates
      #  - email
      #require => Class['apache'],
    }
  }
}
