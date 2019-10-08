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
## Deepspeech model ##

As a PoC we can try to convert the Baidu Deepspeech model, which is delivered in TensorFlow, to generte the OpenVino intermediate representation.

First the deepspeech model needs to be downloaded - follow the instruction on the [DeepSpeech repository](https://github.com/mozilla/DeepSpeech). Once the deepspeech model is downloaded on the host machine unpack it, e.g.:
```
tar zxf deepspeech-0.5.1-models.tar.gz
```
and copy model directory to openvino volume, e.g.:
```
mv deepspeech-0.5.1-models /var/lib/docker/volumes/openvino-vol/_data/
```
Now, run the docker image and run model optimizer:
```
cd /opt/intel/openvino/deployment_tools/model_optimizer/ && 
python3 ./mo_tf.py --input_model /models/deepspeech-0.5.1-models/output_graph.pb --freeze_placeholder_with_value "input_lengths->[16]" --input "input_node,previous_state_h/read,previous_state_c/read" --input_shape "[1,16,19,26],[1,2048],[1,2048]" --output raw_logits,lstm_fused_cell/GatherNd,lstm_fused_cell/GatherNd_1 --disable_nhwc_to_nchw
```
