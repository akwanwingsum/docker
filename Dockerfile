FROM ubuntu:16.04
MAINTAINER Anthony KWS <a.kwanwingsum@futurdigital.fr>

ENV ANDROID_HOME "/opt/android-sdk-linux"
ENV ANDROID_COMPILE_SDK "26"
ENV ANDROID_BUILD_TOOLS "26.0.0"
ENV ANDROID_SDK_TOOLS "25.2.3"

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

# Platform tools
RUN sdkmanager "platform-tools"

# SDKs
# Please keep these in descending order!
RUN sdkmanager "platforms;android-26"
RUN sdkmanager "platforms;android-25"
RUN sdkmanager "platforms;android-24"
RUN sdkmanager "platforms;android-23"
RUN sdkmanager "platforms;android-22"
RUN sdkmanager "platforms;android-21"
RUN sdkmanager "platforms;android-20"
RUN sdkmanager "platforms;android-19"
RUN sdkmanager "platforms;android-17"
RUN sdkmanager "platforms;android-15"
RUN sdkmanager "platforms;android-10"

# build tools
# Please keep these in descending order!
RUN sdkmanager "build-tools;26.0.0"
RUN sdkmanager "build-tools;25.0.3"
RUN sdkmanager "build-tools;25.0.2"
RUN sdkmanager "build-tools;24.0.3"
RUN sdkmanager "build-tools;23.0.3"
RUN sdkmanager "build-tools;22.0.1"
RUN sdkmanager "build-tools;21.1.2"
RUN sdkmanager "build-tools;20.0.0"
RUN sdkmanager "build-tools;19.1.0"
RUN sdkmanager "build-tools;17.0.0"

# Android System Images, for emulators
# Please keep these in descending order!
RUN sdkmanager "system-images;android-25;google_apis;armeabi-v7a"
RUN sdkmanager "system-images;android-24;default;armeabi-v7a"
RUN sdkmanager "system-images;android-22;default;armeabi-v7a"
RUN sdkmanager "system-images;android-21;default;armeabi-v7a"
RUN sdkmanager "system-images;android-19;default;armeabi-v7a"
RUN sdkmanager "system-images;android-17;default;armeabi-v7a"
RUN sdkmanager "system-images;android-15;default;armeabi-v7a"

# Extra
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;m2repository"
RUN sdkmanager "extras;google;google_play_services"

RUN export ANDROID_HOME=$PWD/android-sdk-linux && \
    export PATH=$PATH:$PWD/android-sdk-linux/platform-tools

# ------------------------------------------------------
# --- Install additional packages


# Required for Android ARM Emulator
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libqt5widgets5
ENV QT_QPA_PLATFORM offscreen
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ANDROID_HOME}/tools/lib64

RUN echo Y | DEBIAN_FRONTEND=noninteractive apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

# Required for accepting licences
RUN mkdir -p ${ANDROID_HOME}/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > ${ANDROID_HOME}/licenses/android-sdk-license
RUN echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --all --filter "android-25"

# ------------------------------------------------------
# --- Cleanup and rev num

# Cleaning
RUN apt-get clean


RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg
