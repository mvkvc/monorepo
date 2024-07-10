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

RUN mkdir -p ~/install

RUN curl https://mise.run | sh
RUN echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# Install Erlang
# RUN sudo mkdir -p /erlang && \
#   cd /erlang && \
#   wget -nv -O erlang.tar.gz https://builds.hex.pm/builds/otp/ubuntu-22.04/OTP-27.0.tar.gz && \
#   tar xzf erlang.tar.gz --strip-components=1 && \
#   ./Install -minimal "$(pwd)"

RUN mkdir -p ~/install/erlang && \
  cd ~/install/erlang && \
  wget -nv -O erlang.tar.gz https://builds.hex.pm/builds/otp/ubuntu-22.04/OTP-27.0.tar.gz && \
  tar xzf erlang.tar.gz --strip-components=1 && \
  ./Install -minimal "$(pwd)"

# Erlang runtime dependencies, see https://github.com/hexpm/bob/blob/4fe43eb9853bb95dbfe276957bd7d3f931a451b3/priv/scripts/docker/erlang-ubuntu-jammy.dockerfile
RUN sudo apt-get update && \
  sudo apt-get -y --no-install-recommends install \
  ca-certificates \
  libodbc1 \
  libssl3 \
  libsctp1

# Install Elixir
# RUN mkdir -p ~/install/elixir && \
#   cd ~/install/elixir && \
#   wget -nv -O elixir.zip https://builds.hex.pm/builds/elixir/v1.17.2-otp-27.zip && \
#   unzip -q elixir.zip

ENV PATH="${HOME}/install/erlang/bin:${HOME}/install/elixir/bin:${PATH}"
ENV LANG=C.UTF-8

RUN sudo apt-get -y install pipx
RUN pipx ensurepath
RUN pipx install poetry

RUN curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel 1.8.2 -p ~/install/julia-1.8.2
ENV PATH="$HOME/julia-1.8.2/bin:${PATH}"

RUN curl -sSLf https://scala-cli.virtuslab.org/get | sh
