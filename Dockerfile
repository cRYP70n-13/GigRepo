# METADATA
FROM buildpack-deps:buster-curl

#####################
# ENV AND BUILD ARGS
#####################
ENV DEBIAN_FRONTEND noninteractive

# PACKAGE INSTALLATIONS
RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y ansible apt-transport-https \
    build-essential bzip2 ca-certificates curl dirmngr dnsutils gcc git gzip \
    iproute2 less locales-all make netcat-traditional nginx procps psmisc \
    socat software-properties-common unzip vim-tiny wget zip python \
    php-fpm php-common nano sudo cron tmux 

ENV TERM xterm

##########################################
# PACKAGE INSTALLATIONS
##########################################
COPY scripts/* .
COPY php.ini .
RUN ["bash", "script.sh"]

# PUY Your PACKAGE INSTALLATIONS Here

##############
# COPY FILES
##############
COPY healthcheck.sh /usr/local/sbin/healthcheck.sh
COPY *.yml /tmp/


################
# RUN COMMANDS
################
# Setup the timezone
ENV TZ Africa/Casablanca
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN php -i | grep 'Configuration File'

# Add your commands here
# They are in the script

#################################
# RUN playbook and generate
# file checksums for healthcheck
#################################
RUN set -ex ; chmod 0700 /usr/local/sbin/healthcheck.sh; ansible-playbook -i 'localhost,' /tmp/autoregister.yml; \
	rm /tmp/*

RUN sha512sum /root/* /var/www/html/* /etc/passwd /etc/shadow > /usr/local/lib/.sha512sum; chmod 0400 /usr/local/lib/.sha512sum; chmod 0700 /entrypoint.sh
RUN chmod 0400 /usr/local/lib/.sha512sum
RUN rm /etc/apache2/sites-available/000-default.conf; mv litecart.conf /etc/apache2/sites-available/; mv /etc/apache2/sites-available/litecart.conf /etc/apache2/sites-available/000-default.conf
RUN service apache2 start
RUN ["bash", "create_database.sh"]

##############
# HEALTHCHECK
##############
HEALTHCHECK --interval=12s --timeout=12s --start-period=30s CMD /usr/local/sbin/healthcheck.sh

# RUNTIME
# WORKDIR /
ENTRYPOINT ["sh"]