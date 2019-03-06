#!/usr/bin/env bash
pip  -q --disable-pip-version-check install virtualenv
mkdir /tmp/virtualenvs
virtualenv -q /tmp/virtualenvs/napalm-call-env >/dev/null
cd /tmp/virtualenvs/napalm-call-env/bin
source activate
./pip  -q --disable-pip-version-check install napalm
if [ "$PT_optional_args" != "" ] ; then
  oa="--optional_args '$PT_optional_args'"
fi
if [ "$PT_debug" == "true" ] ; then
  debug="--debug"
fi
echo "Calling" $PT_method "on" $PT_hostname
./napalm $debug --vendor $PT_vendor --user $PT_user --password $PT_password $oa $PT_hostname call $PT_method
deactivate
