FROM mysql:5.7
MAINTAINER Fabio Pellati "fabio.pellati@gmail.com.com"

# Raise user privileges for configuring and installing
USER root

# Some Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Update system timezone
RUN ln -snf /usr/share/zoneinfo/{$TIMEZONE} /etc/localtime && echo {$TIMEZONE} > /etc/timezone

# Update system
RUN apt-get update && apt-get upgrade -y


# Install needed binaries
RUN apt-get -y install vim net-tools telnet

# Clean up APT when done.
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
