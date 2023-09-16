# Neovim Configuration

![][screenshot]

Welcome to my neovim [Personalized Development Environment][PDE]. Primarily
this config is designed to help me be a fast, productive, and efficient creator
and manipulator of text in all the ways it intersects with a
SysAdmin/Programmer/DevOps life. I've primarily crafted this experience for
writing/editing

- Markdown as a general purpose notes + documentation language
- Ansible playbook and role creation for DevOps work
- Bash scripting for system administration
- Python IDE development environment 
- Lightning fast editing of system configuration files

### Supports

- Neovim v0.9+
- Linux and MacOS

## Installation

### Quickstart

```bash
git clone https://github.com/gikeymarcia/neovim-config.git ~/.config/nvim
nvim  # plugins should automatically install
```

### Requirements

- `ripgrep` for nvim-telescope
- `pandoc` and `entr` for markdown previewing features

#### Linters

- `yamllint` for yaml/ansible
- `shellcheck` for Bash scripting

From within nvim you can run `:Mason` to pick language servers to install. You
can manage (install/remove/update) plugins with `:Lazy`

## Useful keymaps

| keymap     | mode | action                                     |
| ------     | ---- | ------                                     |
| `<space>m` | n    | Open HTML preview of .md in $BROWSER       |
| `<F4>`     | n    | Toggle [nvim-tree][nvimtree] file browser  |
| `<F5>`     | n    | Toggle [undo-tree][undotree]               |
| `C-[hjkl]` | n,i  | Switch to different split (vim-directions) |
| `<C-q>`    | n    | Close active window/split                  |
| `gaap`     | n    | Launch [easy-align][] around current table |

## About this Project

I've been using vim/neovim since 2019 but in 2023 decided to reboot fresh and 
throw out my `init.vim` and move to an entirely lua-based configuration. To 
begin I forked the amazing [kickstart.nvim][Kickstart] project and brought in
the aspects of my previous config as I found them helpful.
<br><br>
This is a living project. Every day I work and look for ways to sharpen my knife.
If you should find yourself in this config try `<space>?` to search through my 
keymaps.

[kickstart]: <https://github.com/nvim-lua/kickstart.nvim>
"nvim-lua/kickstart on GitHub"
[PDE]: <https://www.youtube.com/watch?v=QMVIJhC9Veg>
"PDE: A different take on editing code"
[easy-align]: <https://github.com/junegunn/vim-easy-align#usage>
"vim-easy-align"
[undotree]: <https://github.com/mbbill/undotree>
"undotree by mbbill@GitHub"
[nvimtree]: <https://github.com/nvim-tree/nvim-tree.lua>
"nvim-tree.lua: A File Explorer for Nvim"
[screenshot]: <./screenshot.png>
"A view of this config working on editing this project." 
