# Docker Galaxy Tool Generator

This docker image can be used to launch a Galaxy Tool Generator (GTG) for developing Galaxy
tools through web interfaces.

![](images/gtg-home.png)
 
To get necessary docker images:

```
docker pull mingchen0919/gtgdocker
docker pull bgruening/galaxy-stable:17.09
```

## Launch GTG

```
wget https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/launch_dev_env.sh
sh launch_dev_env.sh
```

This script will launch a docker container running the GTG app and another container running
a Galaxy instance. Login to the Galaxy instance with username **admin** and password **admin**
so that you can install tools from tool shed.


## Build Tool XML

GTG provides three ways to build a Galaxy XML file:

* Aurora Galaxy Tool: this option starts with an template file for developing an Aurora Galaxy Tool.
* Uploaded XML: starts with an uploaded XML.
* From scratch: builds XML from scratch.

![](images/create-tool-xml.png)

### Start with an existing XML

In this example we are going to use **Uploaded XML** option to build our tool XML file upon
this [seqtk_seq_1.xml]() and create our final XML file [seqtk_seq_2.xml]().



