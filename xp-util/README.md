# Docker utilite container for Enonic XP
A container full of utillities for Enonic XP. This container is based on the enonic/xp-app container but the internal user is root, not enonic-xp.
## Build local
```
git clone https://github.com/enonic/docker-xp.git
cd docker-xp/xp-util/
docker build --rm -t enonic/xp-util .
```

## Running attached to the storage container xp-home
```
docker run -it --rm --volumes-from xp-home --name xp-util enonic/xp-util
```
