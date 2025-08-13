FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Install software
RUN dnf install -y httpd git && dnf clean all

RUN git clone https://github.com/dylanaraps/neofetch /opt/neofetch && \
    ln -s /opt/neofetch/neofetch /usr/local/bin/neofetch

# Copy content to default web root
COPY web/ /var/www/html/

# Enable httpd
RUN systemctl enable httpd
