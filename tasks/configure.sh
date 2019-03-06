#!/usr/bin/env bash
pip -q --disable-pip-version-check install virtualenv
mkdir /tmp/virtualenvs
virtualenv -q /tmp/virtualenvs/napalm-config-env >/dev/null
cd /tmp/virtualenvs/napalm-config-env/bin
source activate
./pip -q --disable-pip-version-check install napalm
if [ "$PT_optional_args" != "" ] ; then
  oa="--optional_args '$PT_optional_args'"
fi
if [ "$PT_debug" == "true" ] ; then
  debug="--debug"
fi
echo "Current config"
./napalm $debug --vendor $PT_vendor --user $PT_user --password $PT_password $oa $PT_hostname call get_config
if [ "$PT__noop" != "" || "$PT_dry_run" == "true" ] ; then
  noop="--dry-run"
  echo "Simulating applying new config. No changes will be made."
else
  echo "Applying new config."
fi
./napalm $debug --user $PT_user --password $PT_password --vendor $PT_vendor $oa $PT_hostname configure $PT_config_file --strategy $PT_strategy $noop
deactivate
