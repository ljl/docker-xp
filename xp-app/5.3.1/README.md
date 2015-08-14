# Docker container for Enonic XP 5.3.1

## Build local
```
git clone https://github.com/enonic/docker-xp-app.git
cd docker-xp-app/5.3.1
docker build --rm -t enonic/xp-app:5.3.1 .
```

## Start enonic xp container with linked storage container
```
docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app
```

## Start enonic xp container standalone
```
docker run -d -p 8080:8080 --name xp-app enonic/xp-app
```
