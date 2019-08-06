# Minimalistic Dockerized NodeJS app 
that outputs helloworld on http port 8074

## Test this container

To test it, use docker build, since we have a Dockerfile that describes what to build
```
cd dockerdemo/
docker build .
```
This outputs an id of an image, which you will use in the next command
```
docker run -d -p 8074:8074 {{imageId}}
```
-d runs the container "in background" (detached). -p exposes the port also to the host
```
curl localhost:8074
```
You should now see "Hello Christof". 

## Stop the container

First list the containers to get it's id. Search for the one with COMMAND "node app.js" or PORTS "0.0.0.0:8074->8074/tcp" and copy its CONTAINER ID
```
docker ps
docker kill {{containerId}}
```
You stopped the container again.

## Push to Docker Hub

The following commands allow you to publish this image (which you built with "docker build")
```
docker login
docker tag {{imageId}} {{yourDockerLogin}}/{{nameForTheImage}}
docker push {{yourDockerLogin}}/{{nameForTheImage}}
```
Note: This example is pushed to Docker hub under image name qristof/hello-christof
https://cloud.docker.com/u/qristof/repository/list 
