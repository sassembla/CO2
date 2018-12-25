FROM ubuntu:16.04

# install sudo
RUN apt-get update && apt-get -y install sudo \
  && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# install 32bit lib and zip
RUN sudo apt-get -y install lib32stdc++6 lib32z1 zip

# install java
RUN apt-get install -y software-properties-common curl \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk

# download gradle.
RUN cd /usr/local \
  && curl -L https://services.gradle.org/distributions/gradle-4.6-bin.zip -o gradle.zip \
  && unzip gradle.zip \
  && rm gradle.zip

# download Android SDK
RUN sudo apt-get -y install wget \
  && cd /usr/local \
  && wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
  && unzip sdk-tools-linux-4333796.zip \
  && rm -rf sdk-tools-linux-4333796.zip

# set env.
ENV GRADLE_HOME=/usr/local/gradle-4.6
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /usr/local/
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

# gradle setup.
RUN /usr/local/gradle-4.6/bin/gradle -v

# download sdk.
RUN (while sleep 3; do echo "y"; done) | /usr/local/tools/bin/sdkmanager --update
RUN (while sleep 3; do echo "y"; done) | /usr/local/tools/bin/sdkmanager "build-tools;28.0.2"
RUN (while sleep 3; do echo "y"; done) | /usr/local/tools/bin/sdkmanager "platform-tools" "platforms;android-28"


ENTRYPOINT cd home/URLSchemePluginProject/urlschemeplugin && /usr/local/gradle-4.6/bin/gradle assemble

