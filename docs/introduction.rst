What is Galaxy Tool Generator (GTG)?
====================================

GTG is a `Drupal <https://www.drupal.org/>`_ based web application which enables developing and publishing
Galaxy tools through web interfaces. This web application consists of two Drupal modules: `galaxy_tool_generator_ui <https://github.com/MingChen0919/galaxy_tool_generator_ui>`_ and `galaxy_tool_generator <https://github.com/MingChen0919/galaxy_tool_generator_ui>`_, and
depends on the `Drupal webform <https://www.drupal.org/project/webform>`_ module.


.. image:: /_static/images/gtg-home.png

Quick Start Guide
------------------

This repository builds a Docker image that can be used to quickly launch the GTG web application for Galaxy tool development.


To get necessary docker images:

```
docker pull mingchen0919/gtgdocker
docker pull bgruening/galaxy-stable:17.09
```

Launch GTG
~~~~~~~~~~~~~~~~~~~

```
wget https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/launch_dev_env.sh
sh launch_dev_env.sh
```

This script will launch a docker container running the GTG app and another container running
a Galaxy instance. Login to the Galaxy instance with username **admin** and password **admin**
so that you can install tools from tool shed.
