#!/bin/bash

echo "Enabling proxyws module"
a2enmod proxy_wstunnel

echo "Generating proxy config to $APP_PORT_8080_TCP"
WS_URL="$(echo $APP_PORT_8080_TCP | sed 's/^tcp/ws/')/"
PROXYPASS="ProxyPass / $WS_URL"
PROXYPASSREV="ProxyPassReverse / $WS_URL"
echo "
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html

	$PROXYPASS
	$PROXYPASSREV


	ErrorLog /proc/self/fd/2
	CustomLog /proc/self/fd/1 combined
</VirtualHost>

" > /etc/apache2/sites-enabled/000-default.conf


apache2 -DFOREGROUND
