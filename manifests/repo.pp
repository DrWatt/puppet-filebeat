# filebeat::repo
#
# Manage the repository for Filebeat (Linux only for now)
#
# @summary Manages the yum, apt, and zypp repositories for Filebeat
class filebeat::repo {
  $debian_repo_url = "https://artifacts.elastic.co/packages/${filebeat::major_version}.x/apt"
  $yum_repo_url = "https://artifacts.elastic.co/packages/${filebeat::major_version}.x/yum"

  case $facts['os']['family'] {
    'RedHat', 'Linux': {
      if !defined(Yumrepo['beats']) {
        yumrepo { 'beats':
          ensure   => $filebeat::alternate_ensure,
          descr    => 'elastic beats repo',
          baseurl  => $yum_repo_url,
          gpgcheck => 1,
          gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          priority => $filebeat::repo_priority,
          enabled  => 1,
          notify   => Exec['flush-yum-cache'],
        }
      }

      exec { 'flush-yum-cache':
        command     => 'yum clean all',
        refreshonly => true,
        path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      }
    }
    default: {
      fail($filebeat::osfamily_fail_message)
    }
  }
}
