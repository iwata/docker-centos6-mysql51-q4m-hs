centos6-mysql51-q4m-hs
==================

Base docker image to run a MySQL database server with [Q4M](http://q4m.github.io/) and [HandleSocket](https://github.com/DeNA/HandlerSocket-Plugin-for-MySQL)


MySQL version
-------------

Default MySQL version is 5.1.73. But you can specify it, if you use an environmental variable MYVER.

Usage
-----

To pull the image `iwata/centos6-mysql51-q4m-hs` from docker registory, execute the following command:

	docker pull iwata/centos6-mysql51-q4m-hs:latest

To run the image and bind to port 3306:

	docker run -d -p 3306:3306 iwata/centos6-mysql51-q4m-hs

Done!

Environment variables
---------------------

* `MYVER`: Set a specific MySQL version. (default 5.1.73)
* `Q4MVER`: Set a specific Q4M version. (default 0.9.13)
* `HSVER`: Set a specific HandleSocket version. (default 1.1.1)
* `MYSQLDIR`: Set a specific path for MySQL installation directory. (default '/usr/local/mysql')
* `TZ`: Set a specific TimeZone. (default Asia/Tokyo)
