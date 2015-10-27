#!/bin/bash
echo "### Enonic XP demo instance configurator ###"

MY_HOSTNAME=$1

if [[ "x$1" = "x" ]]
	then
	echo "hostname argument is missing, using hostname on instance"
	MY_HOSTNAME="$HOSTNAME.tryme.enonic.io"
fi

PASSWD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c14)

function set_password()
{
	ADMIN_URL=$1
	PWD=$2

	AUTH="su:password"
	JSON="{\"key\":\"user:system:su\",\"password\":\"$PWD\"}"
	eval "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/security/principals/setPassword' -d '$JSON' "
}

function publish_superhero()
{
	ADMIN_URL=$1
	
	AUTH="su:password"
	JSON="{\"ids\":[\"e1f57280-d672-4cd8-b674-98e26e5b69ae\"],\"includeChildren\":true}"
	eval "curl -u $AUTH -H \"Content-Type: application/json\" -XPOST '$ADMIN_URL/rest/content/publish' -d '$JSON' "
}

echo "Creating Enonic XP superhero service"
git clone https://github.com/enonic-io/docker-compose-enonic-xp-superhero.git /srv/superhero
cd /srv/superhero
./configure.sh $MY_HOSTNAME

echo "Launching a superhero"
docker-compose build
docker-compose up -d

echo "Sleeping for 40 seconds to get the demo deployment ready"
sleep 40

echo "Setting up hostfile to point $MY_HOSTNAME to localhost"
echo "127.0.66.1 $MY_HOSTNAME" >> /etc/hosts


echo "### Publishing demo site"
publish_superhero http://$MY_HOSTNAME/admin

echo "### Changing su password to $PASSWD"
set_password http://$MY_HOSTNAME/admin $PASSWD
echo "$PASSWD" > /xp_su_pwd.txt

echo ""
echo "### Finished configuring Enonic XP demo environment ###"

echo "

Hi!

Thank you for signing up for an Enonic XP cloud trial.

We have created a private installation in our Developer Cloud for your testing. You can access the installation here:

Public site: http://$MY_HOSTNAME/
Admin: http://$MY_HOSTNAME/admin
Username: su
password: $PASSWD

Video - How to work with content:
https://www.youtube.com/watch?v=YBOghlzIHDg

Community forum:
https://discuss.enonic.com/

Documentation:
http://xp.readthedocs.org/en/6.1/

Training courses and more:
https://enonic.com/learn

Your installation is available for three days. Just, let us know if you need it longer!

Finally, if you need any help let us know. We can also schedule a GotoMeeting to demo and answer questions.

Vennlig hilsen/Best regards

Morten Øien Eriksen
CEO & Co-Founder

The fastest way from idea to Digital Experience - http://youtu.be/cFfxuWUgcvI

" > /demo-instance.txt

# Installing mailutils to send mail
echo "postfix postfix/mailname string $(hostname -f)" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt-get install -y mailutils

cat /demo-instance.txt | mail -s "new Tryme installation ready on $HOSTNAME" tryme-admins@enonic.io