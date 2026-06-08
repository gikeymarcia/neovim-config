#!/usr/bin/env bash
# Install nvim requirements on MacOS
pipx install nginx-language-server ansible-lint
brew install lua-language-server pyright terraform-ls node rust ripgrep pandoc entr tree-sitter-cli shellcheck shfmt yamllint bash-language-server yaml-language-server
npm install -g @ansible/ansible-language-server
cargo install systemd-lsp
