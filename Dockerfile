FROM ubuntu:focal-20220531
### Using focal because it does not have the black screen issue with tigervnc ###
MAINTAINER Greg Ewing (https://github.com/gregewing)
ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive TZ=Europe/London
COPY scripts /usr/local/bin


RUN echo Starting.\
 && apt-get -q -y clean \
 && apt-get -q -y update \
 && apt-get -q -y autoremove \
 && apt-get -q -y install --no-install-recommends \
                          runit \
                          net-tools \
                          rsyslog \
                          wget \
                          gedit \
                          nano \
                          firefox \
                          software-properties-common \
                          unrar \
                          python3 \
                          openssh-server \
                          tigervnc-standalone-server \
                          tigervnc-common \
                          xfonts-base \
                          xfonts-encodings \
                          xfonts-utils \
                          mate-desktop-environment \
                          ubuntu-mate-wallpapers \
                          ubuntu-mate-icon-themes \
			  mate-applet-brisk-menu \
                          mate-panel \
                          plank \
                          mate-tweak \
                          mozo \
                          novnc \
 && apt-get -q -y remove --purge gnome-screensaver \
 && apt-get -q -y --no-install-recommends full-upgrade \
 && apt-get -q -y autoremove \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# \
 && echo ">> SSHD" \
 && mkdir -p /var/run/sshd \
 && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
 && sed -i 's,^.*PermitEmptyPasswords .*,PermitEmptyPasswords yes,' /etc/ssh/sshd_config \
 && sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd \
# \
 && echo ">> Set up default user" \
 && useradd -ms /usr/local/bin/app-sh.sh app \
 && su -l -s /bin/sh -c "mkdir -p /home/app/.config/autostart ~/Desktop" app \
 && echo Finished.

VOLUME ["/config"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
