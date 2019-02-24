PLUGIN_NAME=urlschemeplugin

mkdir -p project
mkdir -p output

docker rm -f android_plugin 
docker build -f android_plugin.dockerfile -t android_plugin_image --build-arg PLUGIN=$PLUGIN_NAME .
docker run --name android_plugin -v $(pwd)/output:/home/output -e PLUGIN=$PLUGIN_NAME android_plugin_image