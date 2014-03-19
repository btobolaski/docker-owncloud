This builds a docker container with owncloud running in it. It uses a docker volume in order to allow you to persist the data between different containers. It is setup for mysql but, it does not have a linked mysql container. This is because I prefer to run mysql outside of docker but, pull requests are always welcome.

# Usage #

## Building the image ##

run `docker build -t 'name/owncloud' .`

## Running ##

1. You'll either need to build the image or pull `btobolaski/owncloud`.
2. Run it `docker run -d -m 1g -p 127.0.0.1:9000:80 --name="owncloud" -v /var/owncloud:/var/www/owncloud/data btobolaski/owncloud`
3. Setup a reverse proxy to it

```
server {
	     listen 80;
	     server_name owncloud.example.com;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name owncloud.example.com;
	ssl on;
  ssl_certificate /etc/ssl/private/example_com.cert;
  ssl_certificate_key /etc/ssl/private/example_com.key;
  location / {
		proxy_pass http://127.0.0.1:9000;
		proxy_redirect off;
		proxy_buffering off;
		proxy_set_header 	Host	$host;
		proxy_set_header 	X-Real-IP	$remote_addr;
		proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
	}
}```
