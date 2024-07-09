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

RUN mkdir -p ~/install

RUN curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel 1.8.2 -p ~/install/julia-1.8.2
ENV PATH="$HOME/julia-1.8.2/bin:${PATH}"

RUN curl -sSLf https://scala-cli.virtuslab.org/get | sh

# RUN sudo apt install pipx
# RUN pipx ensurepath
# RUN pipx install poetry
