FROM mvkvc/critique:base

COPY . /root

WORKDIR /root

RUN python3.10 -m pip install -r py/requirements.txt

RUN mix deps.get
RUN mix compile

RUN chmod +x /root/entrypoint.sh

CMD [ "/root/entrypoint.sh" ]

