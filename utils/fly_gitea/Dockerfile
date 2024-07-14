FROM gitea/gitea:1.17

COPY ./custom/ /app/custom/

RUN apk --no-cache add asciidoctor freetype freetype-dev gcc g++ libpng libffi-dev py-pip python3-dev py3-pip py3-pyzmq
# install any other package you need for your external renderers

RUN pip3 install --upgrade pip
RUN pip3 install -U setuptools
RUN pip3 install jupyter docutils
# add above any other python package you may need to install
