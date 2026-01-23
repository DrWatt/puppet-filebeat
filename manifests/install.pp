# filebeat::install
#
# A private class to manage the installation of Filebeat
#
# @summary A private class that manages the install of Filebeat
class filebeat::install {
  case $facts['kernel'] {
    'Linux':   {
      if $filebeat::manage_repo {
        class { 'filebeat::repo': }
        Class['filebeat::repo'] -> Class['filebeat::install::linux']
      }
      class { 'filebeat::install::linux':
        notify => Class['filebeat::service'],
      }
      contain filebeat::install::linux
    }
    default:   {
      fail($filebeat::kernel_fail_message)
    }
  }
}
