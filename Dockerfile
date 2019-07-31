# Using ubi7 base image for mongod can update to stacks-node-rhel8 when mongod available
FROM registry.redhat.io/codeready-workspaces/stacks-node

ARG MAVEN_VERSION=3.6.1
ARG MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz

USER root

# Mongod in container for local testing
COPY mongodb-org-3.6.repo /etc/yum.repos.d/
COPY google-chrome.repo /etc/yum.repos.d/

# Install
RUN yum install -y rh-python36.x86_64 libXScrnSaver xdg-utils google-chrome-stable compat-openssl10 mongodb-org-server mongodb-org-tools mongodb-org-shell git curl gcc-c++ automake python2 python36 wget psmisc && \    
    /opt/rh/rh-python36/root/usr/bin/pip3 install ansible && \
    mkdir -p /usr/share/maven && \
    curl -fsSL ${MAVEN_URL} | tar -xzC /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    yum clean all

# Common shell things
RUN echo "source scl_source enable rh-python36" >> /etc/bashrc
RUN echo "git config --global http.sslVerify false" >> /etc/bashrc

# ENV vars for stu
ENV MAVEN_HOME /projects \ 
    MAVEN_CONFIG ${MAVEN_HOME}/.m2 \
    MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1" \
    CHROME_BIN=/bin/google-chrome

# Install jq
# http://stedolan.github.io/jq/
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  chmod +x /usr/local/bin/jq

# Add Let's Encrypt CA to OS trsuted store
RUN curl -o /etc/pki/ca-trust/source/anchors/lets-encrypt-x3-cross-signed.crt https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt && \
    update-ca-trust extract

# Default User
USER 1001
