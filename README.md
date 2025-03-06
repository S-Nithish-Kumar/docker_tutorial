# Docker Tutorial
From [Articulated Robotics Youtube Channel](https://www.youtube.com/playlist?list=PLunhqkrRNRhaqt0UfFxxC_oj7jscss2qe)

## Docker Installation
> [!NOTE]  
> Do not install using:
> ```sudo apt install docker.io```  
> Instead follow the [docker's documentation](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)

Install using the convenience script

1. ```curl -fsSL https://get.docker.com -o get-docker.sh```

This will download the ***get-docker.sh*** script

2. ```sudo sh ./get-docker.sh```

## Post Installation Steps
> [!TIP]  
>[Post installation steps documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

1. Create the **docker** group
```sudo groupadd docker```

2. Add your user to the **docker** group
```sudo usermod -aG docker $USER```

3. To check whether docker service is enabled
```systemctl is-enabled docker```

> [!TIP]  
> To Enable ***docker*** service  
> ```sudo systemctl enable docker.service```  
> ```sudo systemctl enable containerd.service```

4. Restart the computer to enable the 'group' changes

5. Test the docker installation ```docker run hello-world```

## Docker commands
> [!TIP]  
> [Docker commands documentation](https://docs.docker.com/reference/cli/docker/image/)


### 1. List the available images 
```docker image list```

### 2. To download image from docker hub
 ```docker image pull ros:humble```   
 or   
 ```docker pull ros:humble``` 

**Format:**  
```docker image pull <image_name:tag> ```  
or   
```docker pull <image_name:tag>```
- image_name - Similar to gitub Repository
+ tag - It's like Variant

### 3. Deleting a docker image
``` docker image rm -f hello-world```  

> [!NOTE]  
If there is an existing container of this image, then the image cannot be deleted. Using ***-f*** will force delete the image.

### 4. Run an existing image in a docker container  
```docker container run -it ros:humble```

- i - Interactive
+ t - TTY (Give me a terminal that I can type in)

> [!NOTE]
> - When a container is created it will be assigned a **random name** by default
> + Specific name can be provided by the user when creating the container as well  
> Format: ```docker run --name <containter_name> <image_name:tag>```


### 5. List existing docker containers
To list only the active containers:  
``` docker container list```
or
``` docker ps```

To list all containers (i.e., including containers created previously and no longer active):  
``` docker container list -a```
or ```docker ps -a```

### 6. Stop a docker container
```docker container <container_name>```  

Container name can be obtained using the command which will list all the existing containers along with their names:    
```docker container list```

### 7. Start a deactivated container
To do this obtain the **container's name** using: ```docker ps -a```

To start the deactivated container again: ```docker container start -i <container_name>```

> [!NOTE]
> When restarting the deactivated container it is not required to use **'-t'** flag, as it would have been allocated already when creating the container.

### 8. Deleting containers
Delete one by one: ```docker container rm <container_name>```

Delete all at once: ```docker container prune```

> [!TIP]  
> Delete the container immediately after stopping/running:   
> ```docker run --rm --name <container_name> <image_name:tag>```

### 9. Open another terminal of an activate container
Command to open a terminal:  
```docker container exec -it <container_name> /bin/bash```

Similary, any other command can also be executed:  
```docker container exec -it <container_name> ls```

Format:  
``` docker containter exec -it <container_name> <command>```


## Creating Dockerfile and Custom Image
> **Need for Custom Image**
> - When creating docker container from an existing image, any additions/ changes made in one container does not reflect in another container.  
> + Inorder to retain the changes, the base image itself can be modified and a new custom image can be built.
> * The custom image can be create by defining the requirements in a **Dockerfile**.

### Example of Creating a Dockerfile
1. Create a folder ***my_project*** .
2. Inside ***my_project folder*** create a file and name it ***Dockerfile***.
3. Create a folder named ***config*** and inside that folder create a file named ***my_config.yaml***

>> **Folder structure**  
├── my_project  
│   ├── config  
│   │   └── my_config.yaml  
│   └── Dockerfile

4. Inside ***my_config.yaml*** file, type something and save it. (This is an example to show how a folder or file can included while creating a custom docker image)   
5. Inside ***Dockerfile*** include the following   
>>- Include the base image  
```From ros:humble```   
>> + Base is barebone and doesn't even contain **nano** text editor 
```RUN apt-get update && apt-get install -y nano && rm -rf /var/lib/apt/lists/*```
>>* Copy the ***config*** folder to ***site_config*** folder which will be created inside the docker image.
```COPY config/ /site_config/```

### Building the Docker Image
1. Change directory to ***my_project*** folder
2. Use the following command to build the docker image  
```docker image build -t my_image .```  
**Format:**   
```docker image build -t <image_name:tag (optional)> <Dockerfile_location>```
3. To run the docker image in a container  
```docker container run -it my_image```  
**Format:**  
```docker container run -it <image_name>```
4. You can notice that a new folder named ***site_config*** is created and the ***my_config.yaml*** file is copied to this folder. This file can now be edited.

> [!TIP]  
>- In the previous two sections, we saw how to create (copy) folder in the docker image from the local storage.
>+ However, in many cases it might be useful to mount the local folder with the docker container.
>* Here is an example that demonstrates this:
>   - First create a directory with the following structure:  
├── my_code  
│   └── source  
│   │   └── something.py  
├── my_project  
│   ├── config  
│   │   └── my_config.yaml  
│   └── Dockerfile
>   + Optionally, add something in the ***something.py*** file.
>   * Lets say now the target is to mount ***source*** folder with the docker container.  
>     ```docker container run -it -v /home/nithish/docker_tutorial/my_code/source:/my_source_code my_image```  
>     **Format:**   
      ```docker container run -it -v <source_folder>:<destination_folder> <image_name>```
>   * Once the folder is mounted, new file (here named as ***new_file.yaml***) can be created inside the docker container. And this file will get reflected in the local storage as well.  
>  
>       **Folder Structure:**  
├── my_code  
│   └── source  
│       ├── ***new_file.yaml***   
│       └── something.py  
├── my_project  
│   ├── config  
│   │   └── my_config.yaml  
│   └── Dockerfile  
>   - However, any file created will be created under ***root*** user and cannot be accessed without ***root*** previlege. 

> [!NOTE]  
By default, all commands executed in docker are under ***root*** previlege.

## Crafting Dockerfile 
> ### Overview  of the section
> Source: Crafting your Dockerfile - [Video 2 link](https://youtu.be/RbP5cARP-SM?t=0s)  
>
> This section focuses on the following:  
> 1. Create an image with graphic tools built-in (such as rviz, gazebo).   
Note: The previously used base image ***ros:humble*** does not contain these graphic tools built-in but could be downloaded inside the container if needed.
> 2. Provide ***user*** previlege while using docker. i.e., execute commands as regular user.  
> 3. ***Network configuration*** while lauching the container.

> [!NOTE]  
> Dockerfile from previous sections will be modified to meet the objectives as listed in the overview section.

1. **Change ROS Base Image Containing Graphic Tools**  
Change the following command:  
~~```FROM ros:humble```~~ -->  
```FROM osrf/ros:humble-desktop-full```

2. **Create a non-root user**  
Add the following commands in the ***Dockerfile***:  
   ```
   ARG USERNAME=ros

   ARG USER_UID=1000
   ARG USER_GID=$USER_UID


   # Create a non-root user

   RUN groupadd -gid $USER_GID $USERNAME\  
   && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \  
   && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config
   ```

   > [!NOTE]  
   > + **ARG** are arguments and can be changed during Image building process.
   > - Usually, in base computer, user is created during Linux installation and by default the UID **1000** is assigned.
   > + For consequent users that are created, the UID will be incremented by 1.  
   > * **-s /bin/bash** sets the user's login shell to bash.  
   > - **-m** creates the user's home directory if it doesn't exist.

3. **Run the image in a container with user previlege**  
   ```
   docker container run -it --user ros -v /home/nithish/docker_tutorial/my_code/source:/my_source_code my_image
   ```

   **Format:**  
   ```
   docker container run -it --user <user_name> -v <source_folder>:<destination_folder> <image_name>
   ```

   > [!Note]  
   Check for the **user name** in **Dockerfile**

4. Now whenever a file is created under this user name (USERID: 1000), it can accessed both by the docker container and local computer **without** ***sudo*** previlege. Note, this is possible only because the **USERID** of the local computer is also **1000**.

   - To demonstrate this, a new file named ***newer_file.txt*** is created.

     **Folder Structure:**  
   ├── my_code  
│   └── source  
│       ├── ***newer_file.txt***  
│       ├── new_file.yaml  
│       └── something.py  
├── my_project  
│   ├── config  
│   │   └── my_config.yaml  
│   └── Dockerfile  


5. **Set up sudo**
Add the following command in the **Dockerfile** to provide ***sudo*** access to the **non-root user**.
   ```
   RUN apt-get update \  
   && apt-get install -y sudo \
   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\  
   && chmod 0440 /etc/sudoers.d/$USERNAME \
   && rm -rf /var/lib/apt/lists/*
   ```

6. With the sudo previlege, the non-root user can create a file sudo access. Means the file can be accessed by the docker container and the local computer only with sudo previlege.

   - To demonstrate this, a new file named ***test.txt*** is created.

      **Format Structure:**  
   ├── my_code  
│   └── source  
│       ├── newer_file.txt  
│       ├── new_file.yaml  
│       ├── something.py  
│       └── ***test.txt***  
├── my_project  
│   ├── config  
│   │   └── my_config.yaml  
│   └── Dockerfile  

7. **Network configuration while starting the containter**
   ```
   docker container run -it --user ros --network=host --ipc=host -v /home/nithish/docker_tutorial/my_code/source:/my_source_code my_image
   ```

   - --network=host; Allows host's network interface to be accessed
   + --ipc=host; Inter-Process Communication enables communication between container and host computer.

8. **Crafting the entrypoint.sh file**  
***entrypoint.sh*** allows you to define a script that runs every time the container starts.

   Create a new file named ***entrypoint.sh*** in the same directory where the ***Dockerfile*** is and add the following in it.
   ```
   #!/bin/bash

   set -e

   source /opt/ros/$ROS_DISTRO/setup.bash

   echo "Provided arguments: $@"

   exec $@
   ```

   - **set -e**: Enables "exit on error" mode. If any command in the script fails (returns a non-zero exit code), the script will immediately terminate. This helps ensure errors are not silently ignored.

   + **$@** represents all positional parameters (arguments) provided when running the script. 

9. **Update the Dockerfile to execute the entrypoint.sh file**

   ```
   COPY entrypoint.sh /entrypoint.sh

   # Execute entrypoint.sh in /bin/bash
   ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]


   # Pass arguments to the entrypoint.sh file
   # Array of arguments can also be passed
   # Arguments can also be passed directly from the command line while starting the container

   CMD ["bash"]
   ```

   Example command to run the container with argument passed from command line
   ```
   docker container run -it --user ros --name carom_container --network=host --ipc=host -v /home/nithish/monocular_object_detection/CAROM:/home/ros/carom my_image ros2 topic list
   ```

### Providing Docker Container Access to Graphics
**Steps involved:**  
1. Provide the docker container access to **X server**, which manages graphical displays on Unix-like systems. 
   > [!NOTE]   
The below command should be typed in the base computer.
- ```xhost +``` Provides access to any client to connect to the X Server
+ ```xhost +local:``` Grants access only for all local users on the machine. ***Use this always***.
- ```xhost -``` To revoke permissions.

2. Add the following arguments while running the docker container.
- ```-v /tmp/.X11-unix:/tmp/.X11-unix:rw```
X11 uses Unix domain sockets (located in /tmp/.X11-unix) for communication between X clients (applications) and the X server (display server). By mounting this directory, the container can communicate with the host's X server to render graphical interfaces.
+ ```--env=DISPLAY``` 
The DISPLAY variable tells applications where to send their graphical output.   
For example: **DISPLAY=:0** means the application should render its GUI on the first screen of the host machine.

   **Example command:**
   ```
   docker container run -it --user ros --network=host --ipc=host -v /home/nithish/monocular_object_detection/CAROM:/home/ros/carom -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY my_image
   ```

3. To check whether graphics is working in docker containter, run ```rviz2```


### Sourcing ros and colcon for autocompletion
1. Create file named ***bashrc*** in the same directory as where the Dockerfile is and insert the following commands.
   ```
   source /opt/ros/humble/setup.bash
   source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
   ```

2. To copy this ***bashrc*** file to the docker image, add the following inside the ***Dockerfile***.  
```COPY bashrc /home/${USERNAME}/.bashrc```

## Accessing Nvidia Graphics Card in the Docker Container
1. Install [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) in the local machine.  
In the terminal of the local machine:  
   1. Configure the production repository:
      ```
      curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
      sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
      sudo tee /etc/apt/sources.list.d/  nvidia-container-toolkit.list
       ```
   2. Update the packages list from the repository:  
   ``` sudo apt-get update```
   3. Install the NVIDIA Container Toolkit packages:  
   ```sudo apt-get install -y nvidia-container-toolkit```

2. Running the docker container with GPU access.  
Include the argument **--gpus all** while running the docker container.
```
docker container run -it --user ros --network=host --ipc=host -v /home/nithish/monocular_object_detection/CAROM:/home/ros/carom -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY --name carom_container --gpus all my_image
```











































