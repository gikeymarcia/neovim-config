#!/bin/bash
# Mikey Garcia, @gikeymarcia
# make HTML webpages from markdown documents
# dependencies: pandoc
# $1 = markdown_input   e.g., my-notes.md
# $2 = html_outpath     e.g., notes.html

umask 0027

md_input=$1
md_fname="$(basename "$md_input")"

if [[ -z $2 ]]; then
  html_file="$HOME/Downloads/.markdown-preview.html"
else
  html_file=$2
fi

hilight=tango
# see styles with `pandoc --list-highlight-styles`
# pygments,espresso,zenburn,kate,monochrome,breezedark,haddock

css="$HOME/.config/nvim/scripts/pandoc/gikeymarcia.css"

pandoc --metadata pagetitle="$md_fname" -V lang=en \
  --self-contained --standalone  --mathjax \
  --css="$css" --highlight-style="$hilight" \
  "$md_input" --from=markdown+implicit_header_references+task_lists \
  --to=html5 -o "$html_file"
