FROM centos:centos6
MAINTAINER Motonori Iwata <gootonori+docker@gmail.com>

ENV MYVER 5.1.73
ENV Q4MVER 0.9.13
ENV HSVER 1.1.1
ENV MYSQLDIR /usr/local/mysql

# install mysql
RUN yum install -y curl wget tar
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

RUN cd /tmp && curl -O http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/mysql-$MYVER.tar.gz
RUN cd /tmp && curl -O http://q4m.kazuhooku.com/dist/q4m-$Q4MVER.tar.gz
RUN cd /tmp && wget https://github.com/DeNA/HandlerSocket-Plugin-for-MySQL/archive/$HSVER.tar.gz

# to compile MySQL
RUN yum install -y gcc gcc-c++ ncurses-devel

ADD ./install-mysql.sh /install-mysql.sh
ADD ./install-q4m.sh /install-q4m.sh
ADD ./install-handlersocket.sh /install-handlersocket.sh
RUN chmod +x /*.sh

RUN /install-mysql.sh

# to compile HandlerSocket
RUN yum install -y libedit libtool which
# メモリやプロセスの状態変化はRUNをまたげないので&&でつなぐ必要がある
RUN service mysql start && /install-q4m.sh && /install-handlersocket.sh
ADD ./my.cnf /etc/my.cnf

EXPOSE 3306
CMD ["service mysql start"]
