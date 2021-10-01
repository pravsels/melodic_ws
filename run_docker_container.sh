
xhost +local:
docker run -it --rm \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --runtime=nvidia \
    --network=host --privileged \
    -v ${PWD}:/root/catkin_ws melodic_ws:latest
