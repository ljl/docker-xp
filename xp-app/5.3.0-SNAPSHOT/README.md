# Docker SNAPSHOT container for Enonic xp
This docker container image contains the latest snapshot of Enonic XP. It should not be used in production and contains the latest build of the Enonic XP code.


## Build local
```
docker build --rm -t enonic/xp-app:5.3.0-SNAPSHOT .
```

## Start enonic xp container with linked storage container
```
docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app:5.3.0-SNAPSHOT
```

## Start enonic xp container standalone
```
docker run -d -p 8080:8080 --name xp-app enonic/xp-app:5.3.0-SNAPSHOT
```
