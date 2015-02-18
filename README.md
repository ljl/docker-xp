# Docker containers for Enonic XP

## Build
See each docker container

## Installation
To install a complete Enonic XP environment use the following commands on a docker host:
```
docker run -it --name xp-home enonic/xp-home
docker run -d --volumes-from xp-home --name xp-app enonic/xp-app
docker run -d --name xp-frontend -p 80:80 --link xp-app:app enonic/xp-frontend

``