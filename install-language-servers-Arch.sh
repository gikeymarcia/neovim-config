#!/usr/bin/env bash
# Install nvim requirements on Arch
pipx install nginx-language-server ansible-lint
sudo pacman -S --needed lua-language-server pyright systemd-lsp ripgrep entr tree-sitter-cli shellcheck shfmt yamllint bash-language-server yaml-language-server
yay -S --needed terraform-ls ansible-language-server pandoc-bin
