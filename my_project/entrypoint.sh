#!/bin/bash

set -e

source /opt/ros/$ROS_DISTRO/setup.bash

echo "Provided arguments: $@"

exec $@