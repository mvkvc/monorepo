FROM mvkvc/critique:base

COPY . /root

WORKDIR /root

RUN mix deps.get
RUN mix compile
