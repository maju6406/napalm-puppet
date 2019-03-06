
# napalm_puppet

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with napalm](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with napalm](#beginning-with-napalm)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
5. [Release Notes](#release-notes)

## Description

This module contains tasks that wrap the Network Automation and Programmability Abstraction Layer with Multivendor (NAPALM) framework.

## Setup

### Setup Requirements

The target machine running the tasks needs to be a Linux machine. It needs to have the following packages installed before you can run the task:  
RHEL/centos  
* epel-release
* python
* python-pip
* python-devel
* libxml2-devel
* libxslt-devel
* gcc
* openssl
* openssl-devel
* libffi-devel

Ubuntu  
* libxslt1-dev
* libssl-dev
* libffi-dev
* python-dev
* python-cffi
* python-pip  

This module includes a `install_dependencies` task that will install all the above requirements for you.

### Beginning with napalm

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

This module contains 4 tasks:
* install_dependencies - this will install the system depdendencies 
* call - make function calls to NAPALM
* configure - configure network devices using a supplied config file
* validate - validate network device configuration using a validation file

Do not run the task on the networking device itself. These tasks are meant to be run on a jump host. These tasks use virtualenv to create an isolated python environment. It will also put some files in the /tmp folder.

An [example plan](plans/example.pp) using all the tasks is included.

## Reference

For more information about NAPALM check out their [homepage](https://napalm-automation.net/) or their Github [repo](https://github.com/napalm-automation/napalm).

## Release Notes

0.1.0 Initial Release
