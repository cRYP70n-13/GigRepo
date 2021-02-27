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
    php-fpm php-common nano sudo cron tmux \
    && rm -rf /usr/src/* /var/lib/apt/lists/* /var/www/html/*

##########################################
# PACKAGE INSTALLATIONS
##########################################

# PUY Your PACKAGE INSTALLATIONS Here

##############
# COPY FILES
##############
COPY healthcheck.sh /usr/local/sbin/healthcheck.sh
COPY *.yml /tmp/


################
# RUN COMMANDS
################
COPY scripts/* .
# RUN ["bash", "script.sh"]

# Setup the timezone
ENV TZ=Africa/Casablanca
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN rm -rf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/

# Add your commands here

#################################
# RUN playbook and generate
# file checksums for healthcheck
#################################
RUN set -ex ; chmod 0700 /usr/local/sbin/healthcheck.sh; ansible-playbook -i 'localhost,' /tmp/autoregister.yml; \
	rm /tmp/*

RUN sha512sum /root/* /var/www/html/* /etc/passwd /etc/shadow > /usr/local/lib/.sha512sum; chmod 0400 /usr/local/lib/.sha512sum; chmod 0700 /entrypoint.sh
RUN chmod 0400 /usr/local/lib/.sha512sum

##############
# HEALTHCHECK
##############
HEALTHCHECK --interval=12s --timeout=12s --start-period=30s CMD /usr/local/sbin/healthcheck.sh

# RUNTIME
# WORKDIR /
# CMD ["tail -f /var/log/nginx/error.log"]
ENTRYPOINT ["/bin/bash", "script.sh"]
