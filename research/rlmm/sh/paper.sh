#!/bin/bash

(
    cd paper &&
        quarto render paper.qmd &&
        quarto convert paper.qmd &&
        mv paper.ipynb ../nbs &&
        cp bibliography.bib ../nbs
)
