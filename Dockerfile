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
    ros-$ROS_DISTRO-desktop=1.4.1-0*

# install other packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-pip  \
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

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

CMD ["bash"]
