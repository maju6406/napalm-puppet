#!/usr/bin/env bash
if [ -f /etc/redhat-release ]; then
  yum -q install -y epel-release
  yum -q install -y python python-pip python-devel libxml2-devel libxslt-devel gcc openssl openssl-devel libffi-devel
elif [ -f /etc/lsb-release ]; then
  apt-get install  -qq -y --force-yes libxslt1-dev libssl-dev libffi-dev python-dev python-cffi python-pip
fi
