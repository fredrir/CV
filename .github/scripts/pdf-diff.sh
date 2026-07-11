#!/usr/bin/env bash
# Render a page-by-page visual diff between the base and PR builds of the CV.
#
# Usage: pdf-diff.sh <base_dir> <head_dir>
#
# Writes:
#   - PNGs into ./diff/  (head pages + per-page diff overlays)
#   - a Markdown report to stdout (used as the sticky PR comment body)
set -uo pipefail

BASE="${1:?usage: pdf-diff.sh <base_dir> <head_dir>}"
HEAD="${2:?usage: pdf-diff.sh <base_dir> <head_dir>}"

EN=CV_Fredrik_Carsten_Hansteen_En
NB=CV_Fredrik_Carsten_Hansteen_Nb
DPI=150

mkdir -p diff
changed_any=0

echo "## 📄 CV preview"
echo
echo "| Document | Page | Status | Pixels changed |"
echo "|----------|:----:|--------|---------------:|"

compare_doc() {
  local job="$1" label="$2"
  local hpdf="$HEAD/$job.pdf" bpdf="$BASE/$job.pdf"

  if [ ! -f "$hpdf" ]; then
    echo "| $label | — | ⚠️ head build missing | — |"
    return
  fi

  pdftoppm -r "$DPI" -png "$hpdf" "diff/${job}-head" >/dev/null 2>&1
  if [ -f "$bpdf" ]; then
    pdftoppm -r "$DPI" -png "$bpdf" "diff/${job}-base" >/dev/null 2>&1
  fi

  local hp
  for hp in diff/"${job}"-head-*.png; do
    [ -e "$hp" ] || continue
    local n="${hp##*-}"; n="${n%.png}"
    local bp="${hp/-head-/-base-}"
    local out="${hp/-head-/-diff-}"

    if [ ! -f "$bp" ]; then
      cp "$hp" "$out"
      echo "| $label | $n | 🆕 new page | — |"
      changed_any=1
      continue
    fi

    local px rc
    px="$(compare -metric AE "$bp" "$hp" "$out" 2>&1)"; rc=$?
    px="${px%% *}"; px="${px%%.*}"

    if [ "$rc" -eq 0 ]; then
      echo "| $label | $n | ✅ identical | 0 |"
    elif [ "$rc" -eq 1 ]; then
      echo "| $label | $n | 🔺 changed | ${px:-?} |"
      changed_any=1
    else
      echo "| $label | $n | 🔺 changed (size differs) | — |"
      changed_any=1
    fi
  done
}

compare_doc "$EN" "English"
compare_doc "$NB" "Norwegian"

echo
if [ "$changed_any" -eq 1 ]; then
  echo "Rendered output changed. Download the **cv-pr-…** artifact from the run to inspect the built PDFs and the per-page diff overlays (changed regions are highlighted in red)."
else
  echo "No rendered differences versus \`main\`. ✅"
fi

# Keep only head renders + diff overlays in the uploaded artifact.
rm -f diff/*-base-*.png
