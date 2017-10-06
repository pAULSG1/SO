FROM ubuntu:16.04

LABEL maintainer="PG"

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y apt-utils \
 less lsof psmisc \
 info man-db \
 vim nano \
 lynx links \
 command-not-found bash-completion mc htop
# p7zip-full sudo byobu net-tools inetutils-ping inetutils-traceroute mtr-tiny tcpdump colordiff

# special prompt
ADD .bash_aliases /etc/skel/

# install and configure SSH
RUN apt-get install -y openssh-server && \
 mkdir /var/run/sshd && \
 echo 'root:qaz123' | chpasswd && \
 sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
 sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# clean up
RUN apt-get clean && \
 rm /var/lib/apt/lists/*.*

# port & volume
EXPOSE 22
VOLUME /home

# start SSH as daemon
CMD ["/usr/sbin/sshd", "-D"]