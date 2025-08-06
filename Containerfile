FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Install software
RUN dnf install -y httpd git && dnf clean all

# Copy content to Apache's default web root
COPY web/ /var/www/html/

# Do stuff
RUN systemctl enable httpd 

RUN git clone https://github.com/dylanaraps/neofetch /opt/neofetch && \
    ln -s /opt/neofetch/neofetch /usr/local/bin/neofetch

CMD ["/usr/bin/bash"]

