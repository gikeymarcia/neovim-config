#!/bin/bash
# Mikey Garcia, @gikeymarcia
# make HTML webpages from markdown
#   update html each time md is edited
# dependencies: entr pandoc markdown-preview.sh
# environment: $BROWSER

# Redirect stdout (1) and stderr (2) to the log file.
LOG="$HOME/.var/markdown-watch.log"
LOG_DIR="$(dirname "$LOG")"
[[ ! -d $LOG_DIR ]] && mkdir "$LOG_DIR"
exec > "$LOG" 2>&1
set -x # show each command (for debugging)
date

umask 0027
md_preview="$HOME/.config/nvim/scripts/pandoc/markdown-preview.sh"

md_in=$1
if [[ -n $2 ]]; then
    html_out=$2
else
    html_out="$HOME/Downloads/.markdown-watch.html"
fi

this_pid=$$
pgrep -u "$(whoami)" -f markdown-preview.sh | grep -v "$this_pid" |
    xargs -I{} -r kill -9 {}  # kill other markdown-watch procs

$md_preview "$md_in" "$html_out"    # create .html from .md
$BROWSER "$html_out" &

# rebuild html on each page edit
echo "${md_in}" | entr -rn "$md_preview" "${md_in}" "${html_out}"
