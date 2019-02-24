# set android version.
ARG ANDROID_BUILD_TOOL_VERSION="build-tools;28.0.2"
ARG ANDROID_PLATFORM_VERSION="platforms;android-28"

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
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /usr/local

ENV PATH /usr/local/gradle-4.6/bin:$PATH
ENV PATH /usr/local/tools/bin:$PATH
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

RUN (while sleep 3; do echo "y"; done) | sdkmanager --update
RUN (while sleep 3; do echo "y"; done) | sdkmanager ${ANDROID_BUILD_TOOL_VERSION}
RUN (while sleep 3; do echo "y"; done) | sdkmanager "platform-tools" ${ANDROID_BUILD_TOOL_VERSION}

ARG PLUGIN
COPY project/$PLUGIN home/$PLUGIN

RUN cd home/$PLUGIN && gradle extractDebugAnnotations

ENTRYPOINT cd home/$PLUGIN && gradle assemble && cp build/outputs/aar/$PLUGIN-release.aar /home/output

