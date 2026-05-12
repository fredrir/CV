#!/usr/bin/env bash
set -e

EN=CV_Fredrik_Carsten_Hansteen_En
NB=CV_Fredrik_Carsten_Hansteen_Nb

case "${1:-all}" in
  en)  latexmk -lualatex -jobname="$EN" english.tex ;;
  nb)  latexmk -lualatex -jobname="$NB" norsk.tex ;;
  all) latexmk -lualatex -jobname="$EN" english.tex
       latexmk -lualatex -jobname="$NB" norsk.tex ;;
  clean)
       latexmk -C -jobname="$EN" english.tex
       latexmk -C -jobname="$NB" norsk.tex ;;
  *)   echo "Usage: $0 [all|en|nb|clean]"; exit 1 ;;
esac
