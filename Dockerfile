FROM ubuntu:16.04
MAINTAINER Anthony KWS <a.kwanwingsum@futurdigital.fr>

ENV ANDROID_HOME "/opt/android-sdk-linux"
ENV ANDROID_COMPILE_SDK "26"
ENV ANDROID_BUILD_TOOLS "26.0.0"
ENV ANDROID_SDK_TOOLS "24.4.1"

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
      wget \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/tools_r${ANDROID_SDK_TOOLS}-linux.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN ls

RUN sdkmanager "platform-tools" # Platform tools
RUN ${ANDROID_HOME}/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK" # SDKs
RUN ${ANDROID_HOME}/sdkmanager "build-tools;ANDROID_BUILD_TOOLS" # Build tool
RUN ${ANDROID_HOME}/sdkmanager "extras;android;m2repository" # Extra
RUN ${ANDROID_HOME}/sdkmanager "extras;google;m2repository" # Extra
RUN ${ANDROID_HOME}/sdkmanager "extras;google;google_play_services" # Extra
    
# Android System Images, for emulators
# Please keep these in descending order!
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-25;google_apis;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-24;default;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-22;default;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-21;default;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-19;default;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-17;default;armeabi-v7a"
RUN ${ANDROID_HOME}/sdkmanager "system-images;android-15;default;armeabi-v7a"

RUN export ANDROID_HOME=$PWD/android-sdk-linux && \
    export PATH=$PATH:$PWD/android-sdk-linux/platform-tools

RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg
