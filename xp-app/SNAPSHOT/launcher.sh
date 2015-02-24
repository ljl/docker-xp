#!/bin/bash
echo "Launching Enonic xp container..."
echo "Setting filesystem permissions"

# Extracting Enonic xp

if [[ ! -d $XP_HOME ]]
	then
		echo "Downloading Enonic XP distro and extracting it to temp folder."
		wget -O /tmp/distro-$XP_DISTRO_VERSION.tar.gz http://repo.enonic.com/public/com/enonic/xp/distro/$XP_DISTRO_VERSION/distro-$XP_DISTRO_VERSION.tar.gz
		cd /tmp ; tar zxvf distro-$XP_DISTRO_VERSION.tar.gz
		mv /tmp/enonic-xp-$XP_DISTRO_VERSION/home /tmp/enonic-xp-$XP_DISTRO_VERSION/home.org

		cp -rf /tmp/enonic-xp-$XP_DISTRO_VERSION/* $XP_ROOT/.
else
	echo "$XP_HOME exists, skipping download of new snapshot."
fi


if [[ -d $XP_HOME ]]
	then
		for XP_DISTRO_DIR in $(ls -1 $XP_ROOT/home.org )
			do
				ABSOLUTE_XP_DISTRO_DIR=$XP_HOME/$XP_DISTRO_DIR
				if [[ ! -d $ABSOLUTE_XP_DISTRO_DIR ]]
					then
					echo "$ABSOLUTE_XP_DISTRO_DIR does not exist, copying files from distro ( $XP_ROOT/home.org/$XP_DISTRO_DIR )..."
					cp -r $XP_ROOT/home.org/$XP_DISTRO_DIR $ABSOLUTE_XP_DISTRO_DIR
				fi
			done

	if [[ -f $XP_HOME/setenv.sh ]]
		then
		echo "Found custom setenv.sh file in home folder, copying it into runtime..."
		rm $XP_ROOT/bin/setenv.sh
		cp $XP_HOME/setenv.sh $XP_ROOT/bin/setenv.sh
	fi

else
	echo "$XP_ROOT/home does not exist, copying files from distro."
	cp -r $XP_ROOT/home.org $XP_HOME
fi
echo "Changing fileownership for files in $XP_ROOT to $XP_USER."
chown -R $XP_USER $XP_ROOT

echo "Starting Enonic xp..."
cd $XP_ROOT/bin ; sudo su -c './server.sh $@' $XP_USER
