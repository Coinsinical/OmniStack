#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://linuxeye.com
#
# Notes: OneinStack for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/oneinstack/oneinstack
Install_libevent() {
	pushd ${oneinstack_dir}/src > /dev/null
	src_url=https://github.com/libevent/libevent/releases/download/release-${libevent_ver}/libevent-${libevent_ver}.tar.gz&& Download_src
	tar zxvf libevent-${libevent_ver}.tar.gz
    ./configure --prefix=${libevent_install_dir}
	make -j ${THREAD} && make install
	popd > /dev/null
}


Install_pecl_event() {
  if [ -e "${php_install_dir}/bin/phpize" ]; then
    pushd ${oneinstack_dir}/src > /dev/null
    phpExtensionDir=$(${php_install_dir}/bin/php-config --extension-dir)
    PHP_detail_ver=$(${php_install_dir}/bin/php-config --version)
    src_url=https://pecl.php.net/get/event-${event_ver}.tgz&& Download_src
    tar xzf event-${event_ver}.tgz
    pushd event-${event_ver} > /dev/null
    ${php_install_dir}/bin/phpize
    ./configure --with-php-config=${php_install_dir}/bin/php-config --with-event-libevent-dir=${libevent_install_dir}
    make -j ${THREAD} && make install
    popd > /dev/null
    if [ -f "${phpExtensionDir}/event.so" ]; then
      echo 'extension=event.so' > ${php_install_dir}/etc/php.d/06-event.ini
      echo "${CSUCCESS}PHP event module installed successfully! ${CEND}"
      rm -rf event-${event_ver}
    else
      echo "${CFAILURE}PHP event module install failed, Please contact the author! ${CEND}" && grep -Ew 'NAME|ID|ID_LIKE|VERSION_ID|PRETTY_NAME' /etc/os-release
    fi
    popd > /dev/null
  fi
}

Uninstall_pecl_event() {
  if [ -e "${php_install_dir}/etc/php.d/06-event.ini" ]; then
    rm -f ${php_install_dir}/etc/php.d/06-event.ini
    echo; echo "${CMSG}PHP event module uninstall completed${CEND}"
  else
    echo; echo "${CWARNING}PHP event module does not exist! ${CEND}"
  fi
}
