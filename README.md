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
- name - Similar to gitub Repository
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





























=======
# docker_tutorial
>>>>>>> 27e6bc8d392e2d262a870bcb67badc61030bdb70
