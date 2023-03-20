bn# OS Demos

This repository contains a standalone container that can run the
course registration example from lectures.  

Nick made this pretty quickly and it's likely to have bugs.  If you
have problems, please feel free to post on Ed.  If you have issues,
please take a look at the code following the directory structure
below--this may give you what you need.  

## Directory structure

This repository contains directories relevant to the demos:
 - `home`:  This is user Alice's home directory, which will be the
   starting point when running the container (and how you can run
   attacks).  
     - When the container is running, this directory is shared
       with the host system--placing files here will make them appear
       inside the container.  
 - `registrar`:  Source code used to create `/home/registrar` inside
   the container.  This contains the vulnerable code we examined in
   lecture, particularly reg.sh.  
     - NOTE: Unlike `home`, this directory is NOT live-updating.  If
       you want to change any of the files here, you can either get a
       shell inside the container as the registrar user, or erase your
       container image and build the image again (instructions below)
	   
## How to use

This repository contains a `Dockerfile` that closely represents the
one that will be deployed to students, with some changes to allow
editing of the web application code.  You can work with the image
using the `run-container` script:

### Initial setup:  build the container image

```
./run-container setup
```

### Starting the container
```
./run-container
```

This will start the container as the user "alice".  You can run the
binary "reg" to access the registration system as in class.  

### Getting a shell (as any user)

Unlike our primary development container, this one just starts the
webserver directly--it doesn't give you a shell.  To get one, open a
new terminal and run:
```
./run-container shell <user>
```

where user is `alice`, `registrar` or `root`.  This will start a shell
inside your running container.  

(Could you do this in your Handin container?  Sure, but it's not going
to get you any closer to finding any vulnerabilities that will count
for credit.)

### Working with the registration system


Here's some examples of using the registration system.

```
# List available courses
$ reg list

# List availability in cs1660 (with students, if admin)
$ reg list cs1660

# Add user to course
$ reg add cs1660 <file with override code>
```

## Other container tasks

Want to play around with the container?  Here are some other helpful
functions.

### Resetting the container

To restart the container from fresh copy of the image, run:
```
./run-container --clean start
```

This will start a new container from the original image, erasing any
changes made to the container filesystem.

Note for development:  this doesn't affect the `webroot` directory,
which is shared with your local machine--any changes you make here are
still saved.  To revert these, revert the changes in your git repo.  

### Erasing the container image

If you want to free up space and delete the container image entirely,
run:
```
./run-container clean-image
```

This deletes any containers and the image itself, (hopefully) removing
it completely from your Docker storage.  

