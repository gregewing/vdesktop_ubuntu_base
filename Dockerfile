FROM ubuntu:latest
MAINTAINER Greg Ewing (https://github.com/gregewing)
ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London
COPY scripts /usr/local/bin

###  Set local repository  ###
RUN echo Starting.\
# && cp /etc/apt/sources.list /etc/apt/sources.list.default \
# && mv /usr/local/bin/sources.list.localrepo /etc/apt/sources.list \
 && apt-get -q -y clean \
 && apt-get -q -y update \
 && apt-get -q -y install --no-install-recommends \
                          runit \
                          net-tools \
                          rsyslog \
                          wget \
                          nano \
                          software-properties-common \
                          unrar \
                          python \
                          openssh-server \
                          tigervnc-standalone-server \
                          mate-desktop-environment \
                          ubuntu-mate-icon-themes \
			  mate-applet-brisk-menu \
                          mate-panel \
                          plank \
                          mate-tweak \
                          mozo \
                          novnc \
                          websockify \
 && apt-get -q -y --no-install-recommends full-upgrade \
 && apt-get -q -y autoremove \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# \
# && echo ">> rsyslog" \
# && head -n $(grep -n RULES /etc/rsyslog.conf | cut -d':' -f1) /etc/rsyslog.conf > /etc/rsyslog.conf.new \
# && mv /etc/rsyslog.conf.new /etc/rsyslog.conf \
# && echo '*.*        /dev/stdout' >> /etc/rsyslog.conf \
# && sed -i '/.*imklog*/d' /etc/rsyslog.conf \
# \
# && echo ">> NoVNC" \
# && wget https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz -O /novnc.tar.gz \
# && tar xvf /novnc.tar.gz \
# && mv /noVNC* /opt/novnc \
# && cp /opt/novnc/vnc_lite.html /opt/novnc/index.html \
# && rm novnc.tar.gz \
# \
# && echo ">> Websockify" \
# && wget https://github.com/novnc/websockify/archive/v0.9.0.tar.gz -O /websockify.tar.gz \
# && tar xvf /websockify.tar.gz \
# && mv /websockify-* /opt/novnc/utils/websockify \
# && rm websockify.tar.gz \
# \
 && echo ">> SSHD" \
 && mkdir -p /var/run/sshd \
 && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
 && sed -i 's,^.*PermitEmptyPasswords .*,PermitEmptyPasswords yes,' /etc/ssh/sshd_config \
 && sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd \
# \
 && echo ">> Set up default user" \
 && useradd -ms /usr/local/bin/app-sh.sh app \
 && su -l -s /bin/sh -c "mkdir -p ~/.config/autostart ~/Desktop" app \
##  Revert to default repositories  ###
# && mv /etc/apt/sources.list.default /etc/apt/sources.list \
 && echo Finished.


VOLUME ["/config"]

EXPOSE 5901 80 443 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
