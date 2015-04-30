#!/bin/bash

function fail {
	echo "ERROR: $1"
	exit
}

if [ -z "$XP_VERSION" ]; then
	fail "XP_VERSION variable not set.";
fi

TC_BASE=http://teamcity.enonic.net/guestAuth/repository/download
REPO_BASE=http://repo.enonic.com/public/com/enonic/xp/distro
BRANCH_URL=$TC_BASE/EnonicXpBranch_Build/.lastSuccessful/dist/distro-$XP_VERSION.zip?branch=$XP_BRANCH
REPO_URL=$REPO_BASE/$XP_VERSION/distro-$XP_VERSION.zip

if [ -z "$XP_BRANCH" ]; then
	DOWNLOAD_URL=$REPO_URL
else
	DOWNLOAD_URL=$BRANCH_URL
fi

echo "Installing Enonic XP distro..."
rm -rf $XP_ROOT
wget -O /tmp/distro.zip $DOWNLOAD_URL
cd /tmp ; unzip distro.zip
mv /tmp/enonic-xp-$XP_VERSION $XP_ROOT

if [[ ! -d $XP_HOME ]]; then
	echo "Copy default home directory..."
	mkdir -p $XP_HOME
	cp -rf $XP_ROOT/home/* $XP_HOME/.
fi

echo "Starting Enonic XP..."
cd $XP_ROOT/bin ; ./server.sh
