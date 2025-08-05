FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Install Apache HTTP server
RUN dnf install -y httpd && dnf clean all

# Copy site content to Apache's default web root
COPY web/ /var/www/html/

# Enable httpd to start at boot
RUN systemctl enable httpd

CMD ["/usr/bin/bash"]

