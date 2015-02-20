#!/bin/bash

echo "Enabling proxyws module"
a2enmod proxy_wstunnel

echo "Generating proxy config to $APP_PORT_8080_TCP"
WS_URL="$(echo $APP_PORT_8080_TCP | sed 's/^tcp/ws/')/"
http_URL="$(echo $APP_PORT_8080_TCP | sed 's/^tcp/http/')/"
PROXYPASS="ProxyPass / $WS_URL"
PROXYPASSREV="ProxyPassReverse / $WS_URL"
echo "
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html

	ProxyPass /admin/event ws://$APP_PORT_8080_TCP_ADDR:$APP_PORT_8080_TCP_PORT/admin/event
	ProxyPassReverse /admin/event ws://$APP_PORT_8080_TCP_ADDR:$APP_PORT_8080_TCP_PORT/admin/event


	ProxyPass / http://$APP_PORT_8080_TCP_ADDR:$APP_PORT_8080_TCP_PORT/
	ProxyPassReverse / http://$APP_PORT_8080_TCP_ADDR:$APP_PORT_8080_TCP_PORT/


	ErrorLog /proc/self/fd/2
	CustomLog /proc/self/fd/1 combined
</VirtualHost>

" > /etc/apache2/sites-enabled/000-default.conf


apache2 -DFOREGROUND
