# Docker container for Enonic XP 6.1.0

## Build local

    git clone https://github.com/enonic/docker-xp-app.git
    cd docker-xp-app/6.1.0
    docker build --rm -t enonic/xp-app:6.1.0 .

## Start Enonic XP container standalone

    docker run -d -p 8080:8080 --name xp-app enonic/xp-app:6.1.0

## Start Enonic XP container with linked storage container

    docker run -d -p 8080:8080 --volumes-from xp-home --name xp-app enonic/xp-app:6.1.0
