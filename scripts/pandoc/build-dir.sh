#!/bin/bash
# Mikey Garcia, @gikeymarcia
# build out a markdown directory into a corresponding directory of html files
# uses pandoc to convert the document
# dependencies: markdown-preview.sh fd

umask 0027

watch_dir=$1
if [[ -n $watch_dir ]]; then
    if [[ ! -d $watch_dir ]]; then
        echo "must pass a directory as first parameter"
    fi
else
    watch_dir="$HOME/.notes"
fi

out_dir=$2
[[ -z $out_dir ]] && out_dir="$HOME/.cache/my-notes"
rm -r "$out_dir" && mkdir -pv "$out_dir"

while IFS= read -r f; do
    dir=$(dirname "$f")
    new_dir=$(printf "%s" "$dir" | sed "s|^$watch_dir|$out_dir|")
    bare_name=$(basename "$f" .md)
    [[ ! -d $new_dir ]] && mkdir -pv "$new_dir"
    markdown-preview.sh "$f" "$new_dir/${bare_name}.html"
    echo " - - - - - - - - "
done <<< "$(find "$watch_dir" -type f -iname "*.md")"

tree "$out_dir"
du -sh "$out_dir"
