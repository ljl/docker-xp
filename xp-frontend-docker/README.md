# Frontend containter for Enonic XP
Uses Apache 2 with mod_proxy websocket tunnel to linked container with alias "app". This container is currently in ALPHA stage and should not be used in production

## Build
```
docker build --rm -t enonic/xp-frontend https://github.com/enonic/xp-frontend-docker.git
```
Or from local filesystem
```
docker build --rm -t enonic/xp-frontend .
```

## Run
This exposes port 80 and links the container to the contianer xp-app
```
docker run -d --name xp-frontend -p 80:80 --link xp-app:app enonic/xp-frontend
```
