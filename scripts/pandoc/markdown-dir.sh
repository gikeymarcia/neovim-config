#!/bin/bash
# Mikey Garcia, @gikeymarcia
# watch directory for changing markdown files
# dependencies: pandoc markdown-preview.sh entr find
# environment: $BROWSER

if [[ -z $1 ]]; then
  srch_dir="$(pwd)"
else
  srch_dir="$1"
fi
[[ ! -d $srch_dir ]] && echo "Must pass a directory in \$1." && exit 1

umask 0027

live_preview="$HOME/Downloads/.live-preview.html"
md_preview="$HOME/.config/nvim/scripts/pandoc/markdown-preview.sh"

# open most recently edited file in BROWSER
"$md_preview" "$(find "$srch_dir" -type f -exec ls -1t {} + | head -n1)" "$live_preview"
$BROWSER "$live_preview" &

# as soon as a new file is edited that becomes $live_preview
find "$srch_dir" -type f -iname "*.md" | 
  entr -rpc "$md_preview" /_ "$live_preview" 
