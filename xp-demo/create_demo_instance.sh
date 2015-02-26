#!/bin/bash
echo "### Enonic XP demo instance configurator ###"

HOSTNAME=$1
PWD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c14)

function set_password()
{
	ADMIN_URL=$1
	PWD=$2

	AUTH="su:password"
	JSON="{\"key\":\"user:system:su\",\"password\":\"$PWD\"}"
	echo "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/security/principals/setPassword' -d '$JSON' "
}

function publish_demosite()
{
	ADMIN_URL=$1
	
	AUTH="su:password"
	JSON="{\"ids\":[\"2dfbdc41-af98-4b3c-a2a9-9dc4814d003a\"]}"
	echo "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/content/publish' -d '$JSON' "
}

echo "### Creating persistant storage container"
#docker run -it --name xp-home-demo enonic/xp-home

echo "### Creating Enonic XP installation"
#docker run -d --volumes-from xp-home-demo --name xp-app-demo enonic/xp-app

echo "### Starting up frontend"
#docker run -d --name xp-frontend -p 80:80 --link xp-app-demo:app enonic/xp-frontend

echo "### Injecting demo module"
#docker exec xp-app-demo wget -O /tmp/demo-1.0.0.jar http://repo.enonic.com/public/com/enonic/xp/modules/demo/1.0.0/demo-1.0.0.jar
#docker exec xp-app-demo cp /tmp/demo-1.0.0.jar /enonic-xp/home/deploy/demo-1.0.0.jar

echo "### Publishing demo site"
publish_demosite http://$HOSTNAME/admin

echo "### Setting up vhost properties"

echo "### Changing su password to $PWD"
set_password http://$HOSTNAME/admin $PWD