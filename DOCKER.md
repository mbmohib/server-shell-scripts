Install docker
`curl -Sl get.docker.com | sh`

To build an image run

`docker build  -t namespace/image-name .`

To run docker image run

`docker run --rm -p 9000:80 -d namespace/image-name`

here
--rm : remove when stop container
-d : run in detach mode
-it : run in interactive mode
-p bind port with docker port

To list docker containers
`docker ps`

To stop docker container
`docker stop [id]`

To remove images
`docker rmi`

To list docker with only ids
`docker run -q`

Remove all docker images

```
docker rmi `docker images -q`
```

List stopped container list
`docker ps -a`

Execute command on running container
`docker exec -it [container_id] sh`

Build with a different docker file
`docker build -t mohib/react-ostad-dev . --file dev.Dockerfile`

Bind volume with exernal folder with docker folder to handle dev mode
`docker run -v /Users/mohib/Works/docker/react-app/src:/home/app/src -p 5173:5173 mohib/react-ostad-dev`

Check Docker logs size specifically
`find /var/lib/docker/containers -name "*.log" -exec du -sh {} \; | sort -rh | head -10`

Delete docker log
`sudo truncate -s [log file path]`

Check Docker disk usage
`docker system df`

Remove all unused container and images
`docker system prune`

Check container ports
`docker container port [containter name]`
