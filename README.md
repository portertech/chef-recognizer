DESCRIPTION
===========

Installs and configures Recognizer, a Graphite Carbon impostor that
sends metrics to Librato Metrics. Recognizer was created at Sonian,
to evaluate Librato Metrics without having to modify instrumentation.

Recognizer is an executable JAR.

COOKBOOK DEPENDENCIES
=====================

* java (available @ http://community.opscode.com/cookbooks/java)

PLATFORMS
=========

* Ubuntu

RECIPES
=======

recognizer::default
-------------------

Installs, configures, and runs the Recognizer service.

recognizer::jar
---------------

Downloads the Recognizer executable JAR.

ATTRIBUTES
==========

default
-------

* `recognizer.version`       - Recognizer version
* `recognizer.user`          - service user
* `recognizer.directory`     - configuration directory
* `recognizer.log.directory` - log directory
* `recognizer.jar.directory` - JAR directory
* `recognizer.jar.max_heap`  - max Java heap to allocate

* `recognizer.librato.email`          - Librato Metrics email
* `recognizer.librato.api_key`        - Librato Metrics API key
* `recognizer.librato.flush_interval` - batch flush interval
* `recognizer.librato.metric_source`  - metric source

* `recognizer.tcp.port`    - TCP socket port
* `recognizer.tcp.threads` - number of TCP server threads

* `recognizer.amqp.host`  - RabbitMQ server host
* `recognizer.amqp.port`  - RabbitMQ server port
* `recognizer.amqp.ssl`   - RabbitMQ ssl settings
* `recognizer.amqp.vhost` - RabbitMQ vhost
* `recognizer.amqp.user`  - RabbitMQ user name
* `recognizer.amqp.pass`  - RabbitMQ user password

EXAMPLES
========

The directory `examples` contains a Bundler Gemfile, Librarian Chef
Cheffile, Vagrant Vagrantfile, and an example role to test and
evaluate Recognizer.
