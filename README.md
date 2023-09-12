# Neovim Configuration

Welcome to my neovim [Personalized Development Environment][PDE]. Primarily this
config is designed to help me be a fast, productive, and efficient creator and manipulator
of text in all the ways it intersects with a SysAdmin/Programmer/DevOps life.
I've primarily crafted this experience for writing/editing

- Markdown as a general purpose notes + documentation language
- Ansible playbook and role creation for DevOps work
- Bash scripting for system administration
- Python IDE development environment 
- Lightning fast editing of system configuration files

### Supports

- Neovim v0.9+
- Linux and MacOS

### Requirements

- `ripgrep` for nvim-telescope
- `pandoc` and `entr` for markdown previewing features

## Features

- `<space>m` in a markdown file to open an HTML preview in your $BROWSER.
  Preview will re-generate each time you save the file.
- `C-[hjkl]` to change between splits.

## About this Project

I've been using vim/neovim since 2019 but in 2023 decided to reboot fresh and 
throw out my `init.vim` and move to an entirely lua-based configuration. To 
begin I forked the amazing [kickstart.nvim][Kickstart] project and brought in
the aspects of my previous config as I found them helpful.

This is a living project. Every day I work and look for ways to sharpen my knife.
If you should find yourself in this config try `<space>?` to search through my 
keymaps.

[kickstart]: <https://github.com/nvim-lua/kickstart.nvim>
"nvim-lua/kickstart on GitHub"
[PDE]: <https://www.youtube.com/watch?v=QMVIJhC9Veg>
"PDE: A different take on editing code"
