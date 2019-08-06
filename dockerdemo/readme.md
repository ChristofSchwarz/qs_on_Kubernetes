# Minimalistic Dockerized NodeJS app 
that outputs helloworld on http port 8074

# Test this container

To test it, use docker build. 
```
cd dockerdemo/
docker build .
```
This outputs an id of an image, which you will use in the next command
```
docker run -d -p 8074:8074 {{imageid}}
```
-d runs the container "in background" (detached). -p exposes the port also to the host
```
curl localhost:8074
```
You should now see "Hello Christof". 

# Stop the container

First list the containers to get it's id. Search for the one with COMMAND "node app.js" or PORTS "0.0.0.0:8074->8074/tcp" and copy its CONTAINER ID
```
docker ps
docker kill {{containerid}}
```
You stopped the container again.

