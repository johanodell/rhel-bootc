FROM registry.redhat.io/rhel10/rhel-bootc:latest

RUN dnf -y install vim htop && \
    dnf clean all
