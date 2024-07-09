FROM gitpod/workspace-full

RUN sudo apt-get -y update
# Erlang
RUN sudo apt-get -y install \
    build-essential \
    autoconf \
    m4 \
    libncurses-dev \
    libwxgtk3.0-gtk3-dev \
    libwxgtk-webview3.0-gtk3-dev \
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

RUN python3 -m pip install --user pipx
RUN python3 -m pipx ensurepath
ENV PATH="$HOME/.local/bin:$PATH"
RUN pipx install poetry
