# openvino-docker
Sets of scripts to run sucessfully create and run OpenVino as a docker container.

## Dockerfile ##

Dockerfile creates a Ubutntu 16.04 container and installs all prerequisites for OpenVino including model optimizer dependencies (for now, for Tensorflow).
Clone the Dockerfile and see Docker section to run the 

## Docker ##

Once the Dockerfile is clone we shall start with the creation of the volume for data exchange with the SW outside the container:
```
docker volume create openvino-vol
```
Next, the container image needs to be created:
```
docker build . -t openvino --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$https_proxy
```
If you do not need proxy, you may drop '--build-arg' options. Creating an image will take few minutes. Once the image is created it can be run in an interactive mode:
```
docker run -it --mount source=openvino-vol,targe=/models openvino
```
