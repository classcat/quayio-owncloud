# OwnCloud

## Summary

Dockerized OwnCloud ( [OwnCloud](https://owncloud.com/) ).
Run OwnCloud under the control of supervisor daemon in a docker container.

Ubuntu Vivid/Trusty images with the following services :

+ owncloud 8.0.2 on apache2
+ supervisord
+ sshd

built on the top of the formal Ubuntu images.

## Maintainer

[ClassCat Co.,Ltd.](http://www.classcat.com/) (This website is written in Japanese.)

## TAGS

+ latest - vivid
+ vivid
+ trusty

## Pull Image

```
$ sudo docker pull classcat/owncloud
```

## Requirement

mysql container to link with mysql root password.

## Usage

```
$ sudo docker run -d --name (container-name) -p 2022:22 -p 443:443 \  
--link (mysql-container-name):mysql \
-v (host-dir-path):(data-dir-path) \
-e ROOT_PASSWORD=(root-password) \  
-e SSH_PUBLIC_KEY="ssh-rsa xxx" \  
-e MYSQL_ROOT_PASSWORD=(mysql-root-password) \  
-e MYSQL_OC_DBNAME=(database-name) \  
-e MYSQL_OC_USERNAME=(database-username) \  
-e MYSQL_OC_PASSWORD=(database-password) \  
-e OC_DATA_PATH=(data-dir-path) \  
classcat/owncloud
```

## Example Usage

```
docker run -d --name owncloud -p 2022:22 -p 80:80 -p 443:443 \  
  --link mariadb:mysql \  
  -v /owncloud-data:/var/www/html/data \  
  -e SSH_PUBLIC_KEY="ssh-rsa xxx" \  
  -e ROOT_PASSWORD=mypassword \  
  -e MYSQL_ROOT_PASSWORD=mysqlpassword \  
  -e MYSQL_OC_DBNAME=owncloud \  
  -e MYSQL_OC_USERNAME=owncloud \  
  -e MYSQL_OC_PASSWORD=owncloudpassword \  
  -e OC_DATA_PATH=/var/www/html/data \  
  classcat/owncloud
```
