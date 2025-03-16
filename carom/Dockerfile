#FROM ros:humble
FROM osrf/ros:humble-desktop-full

RUN apt-get update && apt-get install -y nano && rm -rf /var/lib/apt/lists/*

ARG USERNAME=ros

ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set the environment variable
ENV USERNAME=$USERNAME

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \  
&& mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \  
&& apt-get install -y sudo \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\  
&& chmod 0440 /etc/sudoers.d/$USERNAME \
&& rm -rf /var/lib/apt/lists/*

# Install pip
RUN apt-get update && apt-get install -y pip && rm -rf /var/lib/apt/lists/*

# Install pytorch
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install tqdm
RUN pip install tqdm==4.65.0

# Install pycocotools
RUN pip install pycocotools==2.0.7

COPY entrypoint.sh /entrypoint.sh

COPY bashrc /home/${USERNAME}/.bashrc

WORKDIR /home/${USERNAME}/carom_ws
RUN mkdir src 

COPY carom /home/${USERNAME}/carom_ws/src/carom
COPY autoware_auto_msgs /home/${USERNAME}/carom_ws/src/autoware_auto_msgs


# Execute entrypoint.sh in /bin/bash
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]


# Pass arguments to the entrypoint.sh file
# Array of arguments can also be passed
# Arguments can also be passed directly from the command line while starting the container

CMD ["bash"]