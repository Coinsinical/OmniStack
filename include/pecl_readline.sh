#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://linuxeye.com
#
# Notes: OneinStack for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/oneinstack/oneinstack

Install_pecl_readline() {
  # install re2c libedit
  if [ "${PM}" == "apt-get" ]; then
      apt-get -y update
      apt-get install -y re2c libedit-dev
  elif [ "${PM}" == "yum" ]; then
      yum clean all
      yum install -y re2c libedit-devel
  fi

  if [ -e "${php_install_dir}/bin/phpize" ]; then
    pushd ${oneinstack_dir}/src > /dev/null
    phpExtensionDir=$(${php_install_dir}/bin/php-config --extension-dir)
    PHP_detail_ver=$(${php_install_dir}/bin/php-config --version)
    src_url=https://secure.php.net/distributions/php-${PHP_detail_ver}.tar.gz && Download_src
    tar xzf php-${PHP_detail_ver}.tar.gz
    pushd php-${PHP_detail_ver}/ext/readline > /dev/null
    ${php_install_dir}/bin/phpize
    ./configure --with-php-config=${php_install_dir}/bin/php-config
    sed -i 's@^CFLAGS =.*@CFLAGS = -std=c99 -g@' Makefile
    make -j ${THREAD} && make install
    popd > /dev/null
    if [ -f "${phpExtensionDir}/readline.so" ]; then
      echo 'extension=readline.so' > ${php_install_dir}/etc/php.d/04-readline.ini
      echo "${CSUCCESS}PHP readlne module installed successfully! ${CEND}"
      rm -rf php-${PHP_detail_ver}
    else
      echo "${CFAILURE}PHP readline module install failed, Please contact the author! ${CEND}" && grep -Ew 'NAME|ID|ID_LIKE|VERSION_ID|PRETTY_NAME' /etc/os-release
    fi
    popd > /dev/null
  fi
}

Uninstall_pecl_readline() {
  if [ -e "${php_install_dir}/etc/php.d/04-readline.ini" ]; then
    rm -f ${php_install_dir}/etc/php.d/04-readline.ini
    echo; echo "${CMSG}PHP readline module uninstall completed${CEND}"
  else
    echo; echo "${CWARNING}PHP readline module does not exist! ${CEND}"
  fi
}
