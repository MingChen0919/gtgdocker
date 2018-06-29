# Docker Galaxy Tool Generator

A Docker image to run the Galaxy Tool Generator application. To launch a GTG application, run the command:

```bash
docker run --rm -d -p 80:80 --name GTG \
    -v `pwd`/galaxy_tool_generator:/var/www/html/sites/default/files/galaxy_tool_repository \
    mingchen0919/gtgdocker
```

Open your browser and enter: http://127.0.0.1.
