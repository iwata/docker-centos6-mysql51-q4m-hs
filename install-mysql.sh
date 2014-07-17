#!/bin/sh
set -xe

groupadd mysql
useradd -g mysql mysql

cd /tmp
echo -e "\e[1;32mStarting MySQL5.1 installation.\e[m"
tar zxf mysql-$MYVER.tar.gz
cd mysql-$MYVER

./configure \
    --prefix=$MYSQLDIR \
    --enable-assembler \
    --enable-thread-safe-client \
    --enable-local-infile \
    --enable-shared \
    --with-partition \
    --with-charset=utf8 \
    --with-zlib-dir=bundled \
    --with-big-tables \
    --with-extra-charsets=complex \
    --with-readline \
    --without-debug \
    --enable-shared \
    --disable-dependency-tracking \
    --with-plugins=innobase,myisam \
    --without-docs \
    --without-man \
    -q
make
make install

cd $MYSQLDIR
chown -R mysql:mysql $MYSQLDIR
./bin/mysql_install_db --user=mysql
chown -R root .
chown -R mysql var

cd /tmp/mysql-$MYVER
cp support-files/my-medium.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
