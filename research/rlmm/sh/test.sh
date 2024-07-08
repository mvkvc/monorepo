#! /bin/bash

nbdev_test \
    --do_print \
    --n_workers 4 \
    --file_re "^\d{2}_.*" \
    --skip_folder_re "ipynb_checkpoints"
