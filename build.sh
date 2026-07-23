#!/usr/bin/env bash
set -e

EN=CV_Fredrik_Carsten_Hansteen_En
NB=CV_Fredrik_Carsten_Hansteen_Nb

run_quietly() {
  local description=$1
  local log
  local status

  shift
  log=$(mktemp)

  if "$@" >"$log" 2>&1; then
    printf '✓ %s\n' "$description"
    rm -f -- "$log"
    return
  else
    status=$?
  fi

  printf '✗ %s\n' "$description" >&2
  cat "$log" >&2
  rm -f -- "$log"
  return "$status"
}

case "${1:-all}" in
  en)  run_quietly "Built English CV" latexmk -lualatex -jobname="$EN" english.tex ;;
  nb)  run_quietly "Built Norwegian CV" latexmk -lualatex -jobname="$NB" norsk.tex
       run_quietly "Generated previews" pdftoppm -r 150 -png -f 1 -l 2 "$NB.pdf" images/preview ;;
  all) run_quietly "Built English CV" latexmk -lualatex -jobname="$EN" english.tex
       run_quietly "Built Norwegian CV" latexmk -lualatex -jobname="$NB" norsk.tex
       run_quietly "Generated previews" pdftoppm -r 150 -png -f 1 -l 2 "$NB.pdf" images/preview ;;
  clean)
       run_quietly "Cleaned English build files" latexmk -C -jobname="$EN" english.tex
       run_quietly "Cleaned Norwegian build files" latexmk -C -jobname="$NB" norsk.tex ;;
  *)   echo "Usage: $0 [all|en|nb|clean]"; exit 1 ;;
esac
