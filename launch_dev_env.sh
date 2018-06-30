# shell script to launch an interactive development environment for galaxy tool wrapping.

if [ -d "gtg_dev_dir" ]; then
	echo "gtg_dev_dir directory already exists. Please remove it first."
	exit 1;
else
	mkdir gtg_dev_dir
	mkdir gtg_dev_dir/galaxy_tool_repository
	mkdir gtg_dev_dir/shed_tools
	mkdir gtg_dev_dir/database
fi


# launch GTG
echo ""
echo "Launch GTG container..."
echo ""
docker run --rm -d -p 8080:80 --name GTG \
    -v `pwd`/gtg_dev_dir/galaxy_tool_repository:/var/www/html/sites/default/files/galaxy_tool_repository \
    -v `pwd`/gtg_dev_dir/shed_tools:/var/www/html/sites/default/files/shed_tools \
    mingchen0919/gtgdocker

# launch Galaxy
echo ""    
echo "Launch Galaxy container..."
echo ""
docker run --rm -d -p 8081:80 --name gtg_galaxy \
	-e "ENABLE_TTS_INSTALL=True" \
	-e "GALAXY_CONFIG_BRAND=GTG" \
	-v `pwd`/gtg_dev_dir/shed_tools:/export/shed_tools \
	-v `pwd`/gtg_dev_dir/database:/export/galaxy-central/database \
	bgruening/galaxy-stable:17.09
	
# Open browser
open http://127.0.0.1:8080
open http://127.0.0.1:8081