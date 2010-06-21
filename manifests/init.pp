#
# File: init.pp
#
# Description:
#
#   Master manifest for cassandra
#
# Caveats: 
#

class cassandra::generic {

  #realize( Group[cassandra], User[cassandra] )

  package { cassandra:
    ensure  => "0.6.2-1",
    require => [ 
      Group[cassandra],
      User[cassandra],
    ],
  }

  file {
    cassandra-sysconfig:
      content => template("cassandra/generic.sysconfig.erb"),
      owner   => root,
      group   => root,
      mode    => 0444,
      path    => "/etc/sysconfig/cassandra",
      require => Package[cassandra];
    cassandra-log4j-properties:
      source  => "cassandra/generic.log4j.properties",
      owner   => root,
      group   => root,
      mode    => 0444,
      path    => "/etc/cassandra/log4j.properties",
      require => Package[cassandra];
    cassandra-log4j-tools-properties:
      source  => "cassandra/generic.log4j-tools.properties",
      owner   => root,
      group   => root,
      mode    => 0444,
      path    => "/etc/cassandra/log4j-tools.properties",
      require => Package[cassandra];
    cassandra-storage-conf:
      content => template("cassandra/generic.storage-conf.xml.erb"),
      owner   => root,
      group   => root,
      mode    => 0444,
      path    => "/etc/cassandra/storage-conf.xml",
      require => Package[cassandra];
  }

  service { cassandra:
    ensure => running,
    enable => true,
    status => "/etc/init.d/cassandra status",
    require => [
      File[cassandra-sysconfig],
      File[cassandra-log4j-properties],
      File[cassandra-storage-conf],
      Package[cassandra],
    ],
    subscribe => [
      File[cassandra-sysconfig],
      File[cassandra-log4j-properties],
      File[cassandra-storage-conf],
    ]
  }

}

class cassandra::dev inherits cassandra::generic {

  File[cassandra-sysconfig] {
    source  => template("cassandra/dev.sysconfig.erb"),
  }

  File[cassandra-log4j-properties] {
    source  => "cassandra/dev.log4j.properties",
  }

  File[cassandra-log4j-tools-properties] {
    source  => "cassandra/dev.log4j-tools.properties",
  }

  $cassandra_replication_factor = "1"
  File[cassandra-storage-conf] {
    source  => template("cassandra/dev.storage-conf.xml.erb"),
  }

}

class cassandra::staging inherits cassandra::generic {

  File[cassandra-sysconfig] {
    source  => template("cassandra/staging.sysconfig.erb"),
  }

  File[cassandra-log4j-properties] {
    source  => "cassandra/staging.log4j.properties",
  }

  File[cassandra-log4j-tools-properties] {
    source  => "cassandra/staging.log4j-tools.properties",
  }

  $cassandra_replication_factor = "1"
  File[cassandra-storage-conf] {
    source  => template("cassandra/staging.storage-conf.xml.erb"),
  }

}

class cassandra::production inherits cassandra::generic {

  File[cassandra-sysconfig] {
    source  => template("cassandra/production.sysconfig.erb"),
  }

  File[cassandra-log4j-properties] {
    source  => "cassandra/production.log4j.properties",
  }

  File[cassandra-log4j-tools-properties] {
    source  => "cassandra/production.log4j-tools.properties",
  }

  $cassandra_replication_factor = "3"
  File[cassandra-storage-conf] {
    source  => template("cassandra/production.storage-conf.xml.erb"),
  }

}

# Modeline
# vim:ts=2:et:ai:sw=2
