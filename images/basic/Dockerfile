FROM ubuntu:14.04
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install openssh-server
RUN apt-get -y install python-software-properties
RUN apt-get -y install openjdk-7-jdk
RUN apt-get -y install vim
ADD files /root/init/

CMD ["/root/init/init.sh"]
