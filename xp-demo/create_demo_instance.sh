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
docker run -it --name xp-home-demo enonic/xp-home

read

echo "### Creating Enonic XP installation"
docker run -d --volumes-from xp-home-demo --name xp-app-demo enonic/xp-app

read

echo "### Starting up frontend"
docker run -d --name xp-frontend -p 80:80 --link xp-app-demo:app enonic/xp-frontend

read

echo "### Injecting demo module"
docker exec xp-app-demo wget -O /tmp/demo-1.0.0.jar http://repo.enonic.com/public/com/enonic/xp/modules/demo/1.0.0/demo-1.0.0.jar
docker exec xp-app-demo cp /tmp/demo-1.0.0.jar /enonic-xp/home/deploy/demo-1.0.0.jar

read

echo "### Publishing demo site"
publish_demosite http://$HOSTNAME/admin

read

echo "### Setting up vhost properties"
docker exec xp-app-demo wget -O /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template https://raw.githubusercontent.com/enonic/docker-xp/master/xp-demo/com.enonic.xp.web.vhost.cfg.template
docker exec xp-app-demo sed -i "s/HOSTNAME/$HOSTNAME/g" /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template
docker exec xp-app-demo rm /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg
docker exec xp-app-demo mv /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg.template /enonic-xp/home/config/com.enonic.xp.web.vhost.cfg

read


echo "### Changing su password to $PWD"
set_password http://$HOSTNAME/admin $PWD

read

echo "### Finished configuring Enonic XP demo environment ###"
echo "

--- mail this part to customer ---
Subject: Enonic XP demo instance

Hi.
I see that you have requested a demo installation of Enonic XP.
You can access it here:

Public site: http://$HOSTNAME/
Admin: http://$HOSTNAME/admin 
Username: su
password: $PWD

For documentation, please see https://enonic.com/docs/latest/
And if there are any questions, please contact either Morten, Kristian or me ( I've added Morten and Kristian on cc. )

" > /demo-instance.txt