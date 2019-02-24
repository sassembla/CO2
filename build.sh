if [ "$1" = "" ]
then
    echo "please set project(module) name."
    exit
fi

mkdir -p project
mkdir -p output

docker rm -f android_plugin 
docker build -f android_plugin.dockerfile -t android_plugin_image --build-arg PLUGIN=$1 .
docker run --name android_plugin -v $(pwd)/output:/home/output -e PLUGIN=$1 android_plugin_image