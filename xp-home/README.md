# Empty docker data container for Enonic xp

## Build local
```
docker build -t enonic/xp-home .
```

## Create data container
```
docker run -it --name xp-home enonic/xp-home
```

## Create a docker container with local mounted deploy catalog
```
docker run -it --name xp-home -v /Users/esu/Downloads/enonic-xp-5.0.0-SNAPSHOT/home/deploy:/enonic-xp/home/deploy enonic/xp-home
```

## Attach a simple shell to your current xp-home container
```
docker run -it --rm --volumes-from xp-home enonic/xp-home sh
```