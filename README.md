*This project has been created as part of the 42 curriculum by canguyen.*  

## Description
A small infrastructure composed of different services, running inside a virtual machine.  
The goal is to use Docker to build, configure and connect these services together.   

## Instructions

### Compilation
```bash
make
```

## Project description

### Virtual Machine vs Docker
A Virtual Machine simulates a whole computer, using its own kernel : it's isolated but heavy and slow to start whereas a Docker container only isolates a program and uses the kernel of its host : it's lighter and start quickly.

## Vocabulary
- **(Docker) container** = an isolated environment (processes) in which a program runs, sharing the host's kernel (so lighter than a virtual machine)  
- **(Docker) image** = a static template that contains everything necessary (files, binaries, libraries, configuration) to launch a container  

## Resources
- [Docker doc on container](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/)  
- [Docker doc on image](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)  
- AI was used for technical explanations  
