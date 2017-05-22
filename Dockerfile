FROM ubuntu:16.04

ENV GIT_USER_NAME mrbuild
ENV GIT_USER_EMAIL mrbuild@github.com
ENV DOCKER_USER docker

# Install ROS2 requirements
#RUN locale-gen en_US en_US.UTF-8
#RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN /bin/bash -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv  --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN /bin/bash -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list'
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys D2486D2DD83DB69272AFE98867170598AF249743

RUN apt-get update \
    && apt-get install -y git wget

# Install nvm, Node.js and node-gyp
ENV NODE_VERSION 6.10.3
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
RUN . $HOME/.nvm/nvm.sh
RUN nvm install $NODE_VERSION && nvm alias default $NODE_VERSION \
    && nvm install -g node-gyp

RUN apt-get install -y build-essential cppcheck cmake libopencv-dev libpoco-dev libpocofoundation9v5 libpocofoundation9v5-dbg python-empy python3-dev python3-empy python3-nose python3-pip python3-setuptools python3-vcstool libtinyxml-dev libeigen3-dev

# Dependencies for testing
RUN apt-get install -y clang-format pydocstyle pyflakes python3-coverage python3-mock python3-pep8 uncrustify \
    && pip3 install flake8 flake8-import-order
# Dependencies for FastRTPS
RUN apt-get install -y libasio-dev libtinyxml2-dev

# Configure git
RUN git config --global user.name $GIT_USER_NAME \
    && git config --global user.email $GIT_USER_EMAIL

# Get ROS2 code
RUN mkdir -p ~/ros2_ws/src \
    && cd ~/ros2_ws \
    && wget https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos \
    && vcs import src < ros2.repos

# Build ROS2
RUN cd ~/ros2_ws/ && src/ament/ament_tools/scripts/ament.py build --build-tests --symlink-install
RUN sources ~/ros2_ws/install/local_setup.bash



