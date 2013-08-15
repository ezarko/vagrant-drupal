
class php {

  include apache

  package {["gd","gd-devel","php-gd","php-mbstring","php-pdo","php-pgsql","php-xml"]:
    ensure => installed,
  }->
  file { "/etc/php.ini":
    source => "puppet:///modules/php/php.ini",
    notify => Service['httpd'],
  }

}
