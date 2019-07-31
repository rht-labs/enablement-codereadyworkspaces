# Using ubi7 base image for mongod can update to stacks-node-rhel8 when mongod available
FROM registry.redhat.io/codeready-workspaces/stacks-node

ARG MAVEN_VERSION=3.6.1
ARG MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz

USER root

# Extra repos not part of ubi
COPY mongodb-org-3.6.repo /etc/yum.repos.d/
COPY google-chrome.repo /etc/yum.repos.d/
COPY rhel7.repo /etc/yum.repos.d/

# Install
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y cowsay zsh libXScrnSaver redhat-lsb xdg-utils google-chrome-stable rh-python36.x86_64 libXScrnSaver redhat-lsb xdg-utils google-chrome-stable mongodb-org-server mongodb-org-tools mongodb-org-shell git curl gcc-c++ automake python2 wget psmisc && \
    /opt/rh/rh-python36/root/usr/bin/pip3 install ansible && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh && \
    cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc && \    
    mkdir -p /usr/share/maven && \
    curl -fsSL ${MAVEN_URL} | tar -xzC /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    yum clean all

# Common shell things
RUN echo "source scl_source enable rh-python36" >> /etc/bashrc
RUN echo "git config --global http.sslVerify false" >> /etc/bashrc
RUN echo "git config --global http.sslVerify false" >> /etc/zshrc

# Fixup helpers
COPY fix-api-url.sh /usr/local/bin
RUN echo "source /usr/local/bin/fix-api-url.sh" >> /etc/bashrc
RUN echo "source /usr/local/bin/fix-api-url.sh" >> /etc/zshrc

# ENV vars for stuff
ENV MAVEN_HOME=/projects \
    MAVEN_CONFIG=${MAVEN_HOME}/.m2 \
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
