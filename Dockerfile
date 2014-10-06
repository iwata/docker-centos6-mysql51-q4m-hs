FROM centos:centos6
MAINTAINER Motonori Iwata <gootonori+docker@gmail.com>

ENV MYVER 5.1.73
ENV Q4MVER 0.9.13
ENV HSVER 1.1.1
ENV MYSQLDIR /usr/local/mysql
ENV TZ Asia/Tokyo

RUN echo "ZONE=\"$TZ\"" > /etc/sysconfig/clock

# install mysql
RUN yum install -y curl wget tar ntp && yum -y clean all
RUN rm -f /etc/localtime && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

RUN cd /tmp && curl -O http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/mysql-$MYVER.tar.gz && tar zxf mysql-$MYVER.tar.gz && rm mysql-$MYVER.tar.gz
RUN cd /tmp && curl -O http://q4m.kazuhooku.com/dist/q4m-$Q4MVER.tar.gz && tar zxf q4m-$Q4MVER.tar.gz && rm q4m-$Q4MVER.tar.gz
RUN cd /tmp && wget https://github.com/DeNA/HandlerSocket-Plugin-for-MySQL/archive/$HSVER.tar.gz && tar zxf $HSVER.tar.gz && rm $HSVER.tar.gz

# to compile MySQL
RUN yum install -y gcc gcc-c++ ncurses-devel && yum -y clean all

COPY ./install-mysql.sh /install-mysql.sh
COPY ./install-q4m.sh /install-q4m.sh
COPY ./install-handlersocket.sh /install-handlersocket.sh
RUN chmod +x /*.sh

RUN /install-mysql.sh
ENV PATH $MYSQLDIR/bin:$PATH

# to compile HandlerSocket
RUN yum install -y libedit libtool which && yum -y clean all
# メモリやプロセスの状態変化はRUNをまたげないので&&でつなぐ必要がある
RUN service mysql start && /install-q4m.sh && /install-handlersocket.sh && mysql -u root -h localhost --port 3306 -e "grant all privileges on *.* to root@'%';"

COPY ./my.cnf /etc/my.cnf

ENV LANG en_US.UTF-8
EXPOSE 3306
#ENTRYPOINT ["/usr/local/mysql/bin/mysqld_safe"]
#CMD ["--user=mysql"]
CMD ["/usr/local/mysql/bin/mysqld_safe", "--user=mysql"]
