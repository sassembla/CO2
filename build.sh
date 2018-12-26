mkdir -p project

docker rm -f android_plugin 

docker build -f android_plugin.dockerfile -t android_plugin_image .

docker run --name android_plugin -v $(pwd)/project:/home \
	-e PLUGIN="urlschemeplugin" \
	android_plugin_image