#!/usr/bin/env bash
pip -q --disable-pip-version-check install virtualenv
mkdir /tmp/virtualenvs
virtualenv -q /tmp/virtualenvs/napalm-validate-env >/dev/null
cd /tmp/virtualenvs/napalm-validate-env/bin
source activate
./pip -q --disable-pip-version-check install napalm
if [ "$PT_optional_args" != "" ] ; then
  oa="--optional_args '$PT_optional_args'"
fi
echo "Validating" $PT_hostname with "$PT_validation_file" 
./napalm --vendor $PT_vendor --user $PT_user --password $PT_password $oa $PT_hostname validate $PT_validation_file
deactivate
