FROM tracer0tong/android-emulator:latest
MAINTAINER Sophia Hadash <sophiahadash@gmail.com>

RUN apt-get update \
    	&& apt-get install -y \
    	libgl1-mesa-dev \
    	wget \
    	unzip \
    	openjdk-8-jdk \
    	ffmpeg

ADD whatsapp.apk /whatsapp.apk
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]