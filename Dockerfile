# ------------------------------------------------------------------------------
# Based on the work at https://github.com/kdelfour/cloud9-docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM rafaelsoares/archlinux
MAINTAINER Aidan Harris <mail@aidanharris.io>

# ------------------------------------------------------------------------------
# Install base
RUN pacman -S --needed --noconfirm base base-devel git nodejs npm tmux supervisor libxml2 sshfs apr-util curl wget
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# Add supervisord conf
ADD conf/cloud9.ini /etc/supervisor.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
