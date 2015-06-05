FROM ubuntu:14.04


ENV DEBIAN_FRONTEND noninteractive

# Install MariaDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db && \
  echo "deb http://mariadb.mirror.iweb.com/repo/10.0/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/mariadb.list && \
  apt-get update && \
  apt-get install --force-yes MariaDB-galera-server MariaDB-client -y && \
  apt-get install --force-yes software-properties-common -y && \
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 BC19DDBA && \
  add-apt-repository 'deb http://releases.galeracluster.com/ubuntu trusty main' && \
  apt-get update && \
  apt-get install --force-yes galera-3 galera-arbitrator-3 rsync lsof -y

ADD ./my.cnf /etc/mysql/my.cnf

ENV TERM dumb

# Define default command.
ENTRYPOINT ["mysqld"]

# Expose ports.
EXPOSE 3306 4444 4567 4568
