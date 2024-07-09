FROM gitpod/workspace-full

RUN sudo apt-get -y update
# Erlang
RUN sudo apt-get -y install \
    build-essential \
    autoconf \
    m4 \
    libncurses-dev \
    libwxgtk3.2-dev \
    libwxgtk-webview3.2-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
    xsltproc \
    fop \
    libxml2-utils \
    openjdk-17-jdk
# Elixir
RUN sudo apt-get -y install \
    unzip

RUN curl https://mise.run | sh
RUN echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
