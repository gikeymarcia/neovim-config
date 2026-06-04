#!/usr/bin/env bash
pipx install nginx_language_server ansible-lint
sudo pacman -S --needed lua-language-server pyright systemd-lsp ripgrep entr tree-sitter-cli shellcheck yamllint
yay -S --needed terraform-ls ansible-language-server pandoc-bin
