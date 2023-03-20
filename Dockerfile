FROM ubuntu:jammy

# set environment variables for tzdata
ARG TZ=America/New_York
ENV TZ=${TZ}

# include manual pages and documentation
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8

COPY docker-support/setup.sh /usr/local/bin/setup.sh
COPY docker-support/setup-registrar.sh /usr/local/bin/setup-registrar.sh
COPY docker-support/entrypoint.sh /usr/local/bin/container-entrypoint
COPY .image-version /etc/image-version

# Run initial setup
RUN /usr/local/bin/setup.sh

ADD --chown=registrar:registrar registrar /home/registrar

RUN /usr/local/bin/setup-registrar.sh

# git build arguments
ARG USER=cs1660\ User
ARG EMAIL=nobody@example.com

# configure your environment
USER alice
RUN rm -f ~/.bash_logout

ENTRYPOINT ["container-entrypoint"]

WORKDIR /home/alice
CMD ["/bin/bash", "-l"]
