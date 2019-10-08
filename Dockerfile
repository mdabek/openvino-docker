FROM ubuntu:16.04
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY
ENV socks_proxy $SOCKS_PROXY
ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334.tgz
ARG COPY_DIR=/opt/intel/openvino_img
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer
RUN apt-get update && apt-get install -y --no-install-recommends \
     wget \
     cpio \
     sudo \
     lsb-release && \
     rm -rf /var/lib/apt/lists/*
RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR && \
     wget $DOWNLOAD_LINK && \
     tar xf l_openvino_toolkit*.tgz && \
     cd l_openvino_toolkit* && \
     sed -i 's/decline/accept/g' silent.cfg && \
     ./install.sh -s silent.cfg && \
     rm -rf $TEMP_DIR
 RUN $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh
 # build Inference Engine samples
 RUN mkdir $INSTALL_DIR/deployment_tools/inference_engine/samples/build && cd $INSTALL_DIR/deployment_tools/inference_engine/samples/build && \
     /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && cmake .. && make -j1"
 RUN apt install python3-pip
 RUN pip3 install numpy
RUN cd /opt/intel/openvino/deployment_tools/model_optimizer/install_prerequisites && ./install_prerequisites_tf.sh && ./install_prerequisites.sh
