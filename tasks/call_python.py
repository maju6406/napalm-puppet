#!/usr/bin/env python

import os,sys,subprocess
sys.path.append(os.path.join(os.path.dirname(__file__),
                             '..', '..', 'python_task_helper', 'files'))
from task_helper import TaskHelper

napalm_found = False
try:
    from napalm import get_network_driver
    from napalm.base import ModuleImportError
    napalm_found = True
except ImportError:
    pass

class MyTask(TaskHelper):
  def task(self, args):
    if not napalm_found:
        raise TaskError('napalm error', 'napalm/connection', {'msg': "the python module napalm is required"})        

    hostname = args['hostname']
    username = args['user']
    dev_os = args['vendor']
    password = args['password']
    timeout = 60
    filter_list = 'facts,interfaces,bgp_neighbors'
    implementation_errors = []

    argument_check = {'hostname': hostname, 'username': username, 'dev_os': dev_os}
    for key, val in argument_check.items():
        if val is None:
            raise TaskError('napalm error', 'napalm/connection', {'msg': str(key) + " is required"})

#    if args['optional_args'] is None:
#        optional_args = {}
#    else:
#        optional_args = args['optional_args']

    try:
        network_driver = get_network_driver(dev_os)
    except ModuleImportError as e:
        raise TaskError('napalm error', 'napalm/connection', {'msg': "Failed to import napalm driver: " + str(e)})

    try:
        device = network_driver(hostname=hostname,
                                username=username,
                                password=password,
                                timeout=timeout,
                                optional_args='')
        device.open()
    except Exception as e:
        raise TaskError('napalm error', 'napalm/connection', {'msg': 'cannot connect to device'+ str(e)})

    # retreive data from device
    facts = {}

    NAPALM_GETTERS = [getter for getter in dir(network_driver) if getter.startswith("get_")]

    for getter in filter_list:
        getter_function = "get_{}".format(getter)
        if getter_function not in NAPALM_GETTERS:
            raise TaskError('napalm error', 'napalm/getter', {'msg': "filter not recognized: " + getter})            

        try:
            get_func = getattr(device, getter_function)
            result = get_func(**args.get(getter, {}))
            facts[getter] = result
        except NotImplementedError:
            if ignore_notimplemented:
                implementation_errors.append(getter)
            else:
                raise TaskError('napalm error', 'napalm/connection', {'msg': "The filter {} is not supported in napalm-{} [get_{}()]".format(
                        getter, dev_os, getter)})                        
        except Exception as e:            
            raise TaskError('napalm error', 'napalm/get_func', {'msg': "[{}] cannot retrieve device data: ".format(getter) + str(e)}) 

    # close device connection
    try:
        device.close()
    except Exception as e:
        raise TaskError('napalm error', 'napalm/get_func', {'msg': "cannot close device connection: " + str(e) })
    new_facts = {}
    # Prepend all facts with napalm_ for unique namespace
    for filter_name, filter_value in facts.items():
        # Make napalm get_facts to be directly accessible as variables
        if filter_name == "facts":
            for fact_name, fact_value in filter_value.items():
                napalm_fact_name = "napalm_" + fact_name
                new_facts[napalm_fact_name] = fact_value
        new_filter_name = "napalm_" + filter_name
        new_facts[new_filter_name] = filter_value
    results = {'puppet_facts': new_facts}

    if ignore_notimplemented:
        results['not_implemented'] = sorted(implementation_errors)

    # module.exit_json(**results)
    return {'result': results}

if __name__ == '__main__':
    MyTask().run()