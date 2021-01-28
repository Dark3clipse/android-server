#!/bin/bash

if [[ $EMULATOR == "" ]]; then
    EMULATOR="android-19"
    echo "Using default emulator $EMULATOR"
fi

if [[ $ARCH == "" ]]; then
    ARCH="x86"
    echo "Using default arch $ARCH"
fi
echo EMULATOR  = "Requested API: ${EMULATOR} (${ARCH}) emulator."
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi

# Run sshd
/usr/sbin/sshd

# Detect ip and forward ADB ports outside to outside interface
ip=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
socat tcp-listen:5037,bind=$ip,fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$ip,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &
socat tcp-listen:80,bind=$ip,fork tcp:127.0.0.1:80 &
socat tcp-listen:443,bind=$ip,fork tcp:127.0.0.1:443 &

# Set up and run emulator
if [[ $ARCH == *"x86"* ]]
then
    EMU="x86"
else
    EMU="arm"
fi


# video feed script
mknod /dev/video0 c 81 0
chown root:video /dev/video0 && \
chmod 660 /dev/video0
if [ $? -ne 0 ]; then
    echo "creating /dev/video failed -> did you modprobe 'modprobe v4l2loopback' on host? or does /dev/video0 exist on host?"
    exit 1
fi
echo "woooot display $DISPLAY"
ffmpeg -f x11grab -s 640x480 -i $DISPLAY -vf format=pix_fmts=yuv420p -f v4l2 /dev/video0 &
export QTWEBENGINE_DISABLE_SANDBOX=1


# launch emulator
echo "no" | /usr/local/android-sdk/tools/android create avd -f -n test -t ${EMULATOR} --abi default/${ARCH}
echo "no" | /usr/local/android-sdk/tools/emulator64-${EMU} -avd test -noaudio -no-window -gpu off -camera-back webcam0 -verbose -qemu -usbdevice tablet -vnc :0


# install whatsapp
sleep 10 && adb shell pm list packages | grep whatsapp &> /dev/null
if [ $? == 0 ]; then
    echo 'WhatsApp already installed'
else
    echo 'Installing WhatsApp'
    adb install /whatsapp.apk
fi