# Docker container for Enonic xp

## Build local
```
docker build --rm -t enonic/xp-app .
```

## Start enonic xp container with linked storage container
```
docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app
```

## Start enonic xp container standalone
```
docker run -d -p 8080:8080 --name xp-app enonic/xp-app
```