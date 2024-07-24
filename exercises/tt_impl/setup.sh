#! /bin/bash

ARCH=gs
VER_UBUNTU=20-04
VER_PY=3.8
VER_BUDA=0.18.2
FILE=pybuda-$ARCH-v$VER_BUDA-ubuntu-$VER_UBUNTU-amd64-python$VER_PY.zip
FOLDER_VENV=$(pwd)/.venv
FOLDER_BUDA=.buda

mkdir -p $FOLDER_BUDA
    wget https://github.com/tenstorrent/tt-buda/releases/download/v$VER_BUDA/$FILE -P $FOLDER_BUDA
unzip $FOLDER_BUDA/$FILE -d $FOLDER_BUDA
python -m venv $FOLDER_VENV
source "$FOLDER_VENV"/bin/activate
pip install --upgrade pip
pip install $FOLDER_BUDA/*.whl
# rm -rf $FOLDER_BUDA

