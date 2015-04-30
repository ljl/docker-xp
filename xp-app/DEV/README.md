# Docker DEV container for Enonic XP

This docker container image downloads and starts any XP version. It
is configurable with the following environment variables:

* `XP_VERSION` - Specifies the version of XP. This is required.
* `XP_BRANCH` - The development branch of XP. If this is set, it will fetch
the distro from TeamCity. This requires the user to have company access.

## Build

```
docker build --rm -t enonic/xp-app:DEV .
```

## Start 5.2.0-SNAPSHOT

```
docker run -d -p 8080:8080 -e XP_VERSION=5.2.0-SNAPSHOT enonic/xp-app:DEV
```

## Start 5.2.0-SNAPSHOT on branch XP-111

```
docker run -d -p 8080:8080 -e XP_VERSION=5.2.0-SNAPSHOT -e XP_BRANCH=XP-111 enonic/xp-app:DEV
```
