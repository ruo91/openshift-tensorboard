##################################################
# Title: OpenShift S2I - Google TensorBoard      #
# Date : 2017.10.29                              #
# Maintainer: Yongbok Kim (ruo91@yongbok.net)    #
##################################################

# Use the base images
FROM centos:centos7
LABEL maintainer="Yongbok Kim <ruo91@yongbok.net>"

#### OpenShift Builder ####
# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="TensorBoard" \
    io.k8s.display-name="tensorboard" \
    io.openshift.tags="builder,tensorboard" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///opt/s2i"

#### Packages ####
#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Base.repo \
# && sed -i 's/#baseurl\=http\:\/\/mirror.centos.org/baseurl\=http\:\/\/ftp.daumkakao.com/g' /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all && yum repolist && yum install -y nano net-tools curl epel-release

#### Work Directory ####
WORKDIR "/opt/notebooks"

#### Default PATH ####
ENV TF_HOME $HOME/venvs/tensorflow/bin
ENV PATH $PATH:$TF_HOME

#### TensorBoard ####
RUN yum install -y python2-pip python34-pip python-devel python34-devel

#### Use pip ####
RUN pip2 install --upgrade pip \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade virtualenv \
  && virtualenv --system-site-packages ~/venvs/tensorboard \
  && source ~/venvs/tensorboard/bin/activate \
  && pip3 install tensorflow \
  && pip2 install tensorboard

# TensorBoard
COPY conf/tensorboard.sh /tensorboard.sh
RUN chmod a+x /tensorboard.sh

#### Port ####
# TensorBoard: 6006
EXPOSE 6006

#### Source to Image ####
# Copy the S2I scripts to /opt/s2i since we set the label that way
COPY s2i/bin/ /opt/s2i
RUN chmod -R a+x /opt/s2i

# Allow arbitrary
USER 0
