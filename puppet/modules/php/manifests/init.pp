
class php {

  include apache

  package {["gd","gd-devel","php-gd","php-mbstring","php-pdo","php-pgsql","php-xml"]:
    ensure => installed,
  }->
  file { "/etc/php.d/drupal.ini":
    source => "puppet:///modules/php/drupal.ini",
    notify => Service['httpd'],
  }

}
