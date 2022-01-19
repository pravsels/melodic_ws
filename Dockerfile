FROM osrf/ros:melodic-desktop-full

ENV ROS_DISTRO=melodic
ENV CATKIN_WS=/root/catkin_ws

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-desktop=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

# install Franka Emika, PCL, Octomap and MoveIt packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-libfranka  \
    ros-$ROS_DISTRO-franka-ros  \
    ros-$ROS_DISTRO-moveit  \
    ros-$ROS_DISTRO-moveit-resources  \
    ros-$ROS_DISTRO-octomap*  \
    libpcl-dev  \
    ros-$ROS_DISTRO-pcl-ros  \
    && rm -rf /var/lib/apt/lists/*

# install other packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-pip  \
    python-tk \
    python-catkin-tools \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN pip install lxml

WORKDIR $CATKIN_WS

COPY ./src ./src

# install dependencies
RUN apt update -qq \
    && rosdep update \
    && rosdep install --rosdistro $ROS_DISTRO --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt ./requirements.txt

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN apt update \
    && apt install ros-$ROS_DISTRO-joint-state-publisher-gui \
    && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

CMD ["bash"]
