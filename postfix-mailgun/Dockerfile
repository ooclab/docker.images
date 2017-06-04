From ubuntu:latest
MAINTAINER gwind <lijian@ooclab.com>

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update & Install package here for cache
#RUN sed -i -e 's@archive.ubuntu.com@cn.archive.ubuntu.com@' /etc/apt/sources.list \
RUN apt-get update -y && apt-get dist-upgrade -y \
        && apt-get -y install apt-utils rsyslog \
                postfix sasl2-bin libsasl2-modules \
                net-tools iputils-ping \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir -pv /opt/bin/
COPY assets/start.sh assets/setup_noauth.sh assets/setup_tls.sh assets/build_tls_keys.sh assets/test_sendmail.py /opt/bin/
RUN chmod 755 /opt/bin/start.sh

# Run
CMD ["/opt/bin/start.sh"]
