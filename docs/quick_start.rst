Quick Start Guide
=================

This repository builds a Docker image that can be used to quickly launch the GTG web application for Galaxy tool development.


To get necessary docker images:

.. code-block:: shell

  docker pull mingchen0919/gtgdocker
  docker pull bgruening/galaxy-stable:17.09


.. warning::

  This documentation is under active construction and should be completed by November 17th 2018, so please check back then if you can't find what you need.

Launch GTG
-----------

.. code-block:: shell

  wget https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/launch_dev_env.sh
  sh launch_dev_env.sh

This script will launch a docker container running the GTG app and another container running
a Galaxy instance. Login to the Galaxy instance with username **admin** and password **admin**
so that you can install tools from tool shed.
