FROM ubuntu:xenial

ENV GIT_USER_NAME mrbuild
ENV GIT_USER_EMAIL mrbuild@github.com
ENV DOCKER_USER docker
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y git wget locales sudo

# Install nvm, Node.js and node-gyp
ENV NODE_VERSION 6.10.3
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . $HOME/.nvm/nvm.sh \
    && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION \
    && npm install -g node-gyp \
    && which node \
    && which npm
    
RUN /bin/versions/node/v6.10.3/bin/node -v

RUN which npm

ENV PATH `which node`:$PATH

RUN /bin/bash -c "echo $PATH"
RUN /bin/bash -c "echo `which npm`"
