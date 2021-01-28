# Whatsapp in Docker
Launch a Whatsapp server in a docker container. The aim of this project is to launch a Whatsapp server is a docker container such that whatsapp is no longer needed on personal devices, but can be accessed through services like matrix.

## Setup your server
Whatsapp must be able to scan a QR code. Therefore, we simulate a video device using v4l2loopback.
```
bash setup-host.sh
```

## Run the docker container
```
bash deploy.sh
```

## Setup whatsapp manually
Open the vlc feed
```

```

You can insert commands as follows:
```
docker exec <container-id> adb shell input tap x y
```