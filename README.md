[![Code Climate](https://codeclimate.com/github/factor-io/connector-rackspace/badges/gpa.svg)](https://codeclimate.com/github/factor-io/connector-rackspace)
[![Test Coverage](https://codeclimate.com/github/factor-io/connector-rackspace/badges/coverage.svg)](https://codeclimate.com/github/factor-io/connector-rackspace)
[![Build Status](https://travis-ci.org/factor-io/connector-rackspace.svg?branch=master)](https://travis-ci.org/factor-io/connector-rackspace)
[![Dependency Status](https://gemnasium.com/factor-io/connector-rackspace.svg)](https://gemnasium.com/factor-io/connector-rackspace)
[![Gem Version](https://badge.fury.io/rb/factor-connector-rackspace.svg)](http://badge.fury.io/rb/factor-connector-rackspace)
Factor.io Rackspace Connector
======================

Factor.io Connector for integrating with Rackspace Cloud.

## Installation
Add this to your `Gemfile` in your [Connector](https://github.com/factor-io/connector)
```ruby
gem 'factor-connector-rackspace', '~> 0.0.3'
```

Add this to your `init.rb`  in your [Connector](https://github.com/factor-io/connector)

```ruby
require 'factor/connector/rackspace_compute'
require 'factor/connector/rackspace_compute_flavors'
require 'factor/connector/rackspace_compute_images'
```

The [Connectors README](https://github.com/factor-io/connector#running) shows you how to run the Connector Server with this new connector integrated.

## Setup and Usage
**[Setup your workflows](https://github.com/factor-io/connector-rackspace/wiki/Setup-your-workflows)**: To use the connector in your workflow when you run `factor s` you must setup your `credentials.yml` and `connectors.yml` files. Here is how you can .

**[Usage: Actions and Listeners](https://github.com/factor-io/connector-rackspace/wiki/Actions-and-Listeners)**: This will show you all the actions you can use in your workflows on Rackspace cloud along with some examples.

## Bug reports and pull requests
[Bug reports are very welcome!!](https://github.com/factor-io/connector-rackspace/issues/new)

[So are contributions and pull requests](https://github.com/factor-io/factor/wiki/Contribution).

## Running tests
These tests are functional, they will call out to your Rackspace account and take actions. At the moment only non-intrusive tests (i.e. list/get) are implemented. Soon we'll have create, bootstrap, ssh tests which may incur charges on your account, that is, use at your own risk.

```shell
export RACKSPACE_USERNAME=<username>
export RACKSPACE_API_KEY=<api key>
bundle exec rake
```
