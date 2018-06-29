# Docker Galaxy Tool Generator

![](images/gtg-home.png)

A Docker image to run the Galaxy Tool Generator application. To launch a GTG application, run the command:

```bash
docker run --rm -d -p 80:80 --name GTG \
    -v `pwd`/galaxy_tool_generator:/var/www/html/sites/default/files/galaxy_tool_repository \
    mingchen0919/gtgdocker
```

Open your browser and enter: http://127.0.0.1.

## Launch a Galaxy instance to test the tool

We can use this [docker image](https://github.com/bgruening/docker-galaxy-stable) to launch 
a Galaxy instance for interactively testing our tool. We are going to map the Galaxy 
container's **/export/shed_tools** and the **/export/galaxy-central/database** directories 
to our host machine. When testing the tool, we can tract the job status by monitoring the 
files within the **database** folder. We can integrate tool updates into Galaxy for testing by
overwriting the tool repository in the **shed_tools** folder with the updated **galaxy_tool_directory**.

```
mkdir shed_tools
mkdir database

docker run --rm --name gtg_galaxy -p 8080:80 \
	-e "ENABLE_TTS_INSTALL=True" \
	-e "GALAXY_CONFIG_BRAND=GTG" \
	-v /full/path/to/shed_tools:/export/shed_tools \
	-v /full/path/to/database:/export/galaxy-central/database \
	bgruening/galaxy-stable:17.09 startup > /dev/null 2>&1
```
