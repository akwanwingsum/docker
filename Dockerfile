FROM openjdk:8-jdk
MAINTAINER Anthony KWS <a.kwanwingsum@futurdigital.fr>

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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r$ANDROID_SDK_TOOLS-linux.tgz && \
  tar --extract --gzip --file=android-sdk.tgz && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-$ANDROID_COMPILE_SDK && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-$ANDROID_BUILD_TOOLS && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
  echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository && \
  export ANDROID_HOME=$PWD/android-sdk-linux && \
  export PATH=$PATH:$PWD/android-sdk-linux/platform-tools
